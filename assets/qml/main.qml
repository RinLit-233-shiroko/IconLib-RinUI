import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import RinUI


ApplicationWindow {
    id: window
    title: "Icon Library"
    width: 800
    height: 650
    minimumWidth: 600
    minimumHeight: 400
    visible: true

    property var allIcons: Object.keys(Utils.fontIconIndex)
    property string searchText: ""

    // 过滤后的图标 / Filtered Icons //
    property var filteredIcons: allIcons.filter(function(name) {
        return name.toLowerCase().indexOf(searchText.toLowerCase()) !== -1
    })

    // 复制函数
    function copyToClipboard(copyText) {
        if (!filteredIcons.length > 0) {
            floatLayer.createInfoBar({
                severity: Severity.Warning,
                text: qsTr("No icon selected"),
            })
            return 0
        }

        if (typeof Backend === "undefined") {
            floatLayer.createInfoBar({
                severity: Severity.Error,
                text: qsTr("Backend is not defined"),
            })
            return 0
        }

        Backend.copyToClipboard(
            copyText
        )
        floatLayer.createInfoBar({
            severity: Severity.Success,
            title: qsTr("Copied to clipboard"),
            text: copyText
        })
    }

    Component.onCompleted: {
        floatLayer.createInfoBar({
            severity: Severity.Info,
            title: "Welcome to RinUI Icon Library!",
            position: Position.TopRight,
            timeout: 6000,
            text: "RinUI now provides a Fluent Icon Library with <b>5000+</b> icons.",
        })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(window.height * 0.15, 170)

            Image {
                id: banner
                anchors.fill: parent
                source: "../images/banner.png"
                fillMode: Image.PreserveAspectCrop

                // 裁剪
                Component.onCompleted: {
                    sourceClipRect = Qt.rect(
                        0,
                        0,
                        banner.sourceSize.width * 0.85,
                        banner.sourceSize.height * 0.5
                    )
                }

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: banner.width
                        height: banner.height

                        // 渐变效果
                        gradient: Gradient {
                            GradientStop { position: 0.7; color: Qt.alpha("white", 0.8) }  // 不透明
                            GradientStop { position: 1.0; color: "transparent" }  // 完全透明
                        }
                    }
                }
            }

            RowLayout {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: 56
                    rightMargin: 56
                    topMargin: 38
                }
                Column {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        color: "#fff"
                        typography: Typography.BodyLarge
                        font.bold: false
                        text: qsTr("RinUI")
                    }

                    Text {
                        color: "#fff"
                        typography: Typography.Title
                        text: qsTr("Icon Library")
                    }

                    Text {
                        color: "#fff"
                        typography: Typography.Caption
                        text: qsTr("1.1.0")
                    }
                }
                ColumnLayout {
                    spacing: 8

                    Item {
                        Layout.fillHeight: true
                    }
                    Button {
                        highlighted: true
                        text: qsTr("What is RinUI?")
                        onClicked: rinui_intro_flyout.open()

                        ToolTip {
                            text: qsTr("You're right, but RinUI is a library of Fluent Design icons for Qt Quick (QML).")
                            delay: 500
                            visible: parent.hovered
                        }

                        Flyout {
                            id: rinui_intro_flyout
                            width: 400
                            position: Position.Left
                            text: "<b>RinUI is a Fluent Design UI library for Qt Quick (QML)</b> <br> With just a simple configuration, you can quickly develop an elegant Fluent-style UI interface."
                            buttonBox: [
                                Hyperlink {
                                    text: "Learn more"
                                    icon.name: "ic_fluent_open_20_filled"
                                    openUrl: "https://ui.rinlit.cn/"
                                }
                            ]
                        }
                    }
                }
            }
        }

        // Body
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            spacing: 8

            Text {
                typography: Typography.BodyStrong
                text: qsTr("Fluent Icon Library")
            }

            TextField {
                implicitWidth: 300
                id: searchField
                placeholderText: qsTr("Search")
                onTextChanged: searchText = text
            }

            // 图标 / Icon //
            Frame {
                Layout.fillWidth: true
                color: Theme.currentTheme.colors.backgroundColor
                hoverable: false
                Layout.fillHeight: true
                padding: 0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8


                    // 图标列表  / Icon Grid //
                    GridView {
                        id: iconGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        model: filteredIcons  // 过滤后的图标
                        cellWidth: iconFrame.width + 8
                        cellHeight: iconFrame.height + 8

                        ScrollBar.vertical: ScrollBar {  // 滚动条
                            policy: ScrollBar.AsNeeded
                        }

                        currentIndex: 0

                        delegate: Clip {
                            id: iconFrame
                            property bool isSelected: index === iconGrid.currentIndex

                            radius: 3

                            width: 92
                            height: 92
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width + 4
                                height: parent.height + 4
                                radius: 7
                                color: "transparent"
                                border.color: isSelected ? Theme.currentTheme.colors.primaryColor : "transparent"
                                border.width: isSelected ? 2 : 0
                            }

                            onClicked: iconGrid.currentIndex = index

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                IconWidget {
                                    Layout.fillHeight: true
                                    Layout.alignment: Text.AlignHCenter
                                    size: 36
                                    opacity: 0.9
                                    icon: modelData
                                }

                                Text {
                                    Layout.fillWidth: true
                                    typography: Typography.Caption
                                    horizontalAlignment: Text.AlignHCenter
                                    color: Theme.currentTheme.colors.textSecondaryColor
                                    text: modelData.replace("ic_fluent_", "");
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }

                    // icon信息
                    Rectangle {
                        width: 300
                        Layout.fillHeight: true
                        radius: Theme.currentTheme.appearance.smallRadius
                        color: Theme.currentTheme.colors.systemAttentionBackgroundColor
                        border.width: Theme.currentTheme.appearance.borderWidth
                        border.color: Theme.currentTheme.colors.cardBorderColor

                        Flickable {
                            anchors.fill: parent
                            anchors.margins: 16
                            clip: true
                            contentHeight: contentItem.childrenRect.height

                            ColumnLayout {
                                width: parent.width
                                spacing: 16

                                Column {
                                    Layout.fillWidth: true
                                    Text {
                                        id: iconTitle
                                        width: parent.width
                                        text: filteredIcons.length > 0 ?
                                            filteredIcons[iconGrid.currentIndex].replace("ic_fluent_", "")
                                            : qsTr("No icon selected")
                                        typography: Typography.BodyLarge
                                    }
                                    IconWidget {
                                        icon: filteredIcons.length > 0 ? filteredIcons[iconGrid.currentIndex] : ""
                                        size: 64
                                    }
                                }

                                Item {
                                    height: 16
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    Text {
                                        typography: Typography.Caption
                                        color: Theme.currentTheme.colors.textSecondaryColor
                                        text: qsTr("Icon name")
                                    }
                                    RowLayout {
                                        width: parent.width

                                        Text {
                                            id: iconName
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                            wrapMode: Text.Wrap
                                            font.pixelSize: 15
                                            font.family: "Consolas"
                                            text: filteredIcons.length > 0 ?
                                                filteredIcons[iconGrid.currentIndex]
                                                : qsTr("No icon selected")
                                        }

                                        // 复制按钮
                                        ToolButton {
                                            icon.name: "ic_fluent_copy_20_regular"
                                            onClicked: copyToClipboard(iconName.text)
                                        }
                                    }
                                }

                                // qml
                                Column {
                                    Layout.fillWidth: true
                                    spacing: 8
                                    Text {
                                        typography: Typography.Caption
                                        color: Theme.currentTheme.colors.textSecondaryColor
                                        text: qsTr("QML code")
                                    }
                                    RowLayout {
                                        width: parent.width

                                        Text {
                                            id: qmlCode
                                            Layout.fillWidth: true
                                            wrapMode: Text.Wrap
                                            font.family: "Consolas"
                                            font.pixelSize: 15
                                            text: filteredIcons.length > 0 ?
                                                "icon.name: \""+filteredIcons[iconGrid.currentIndex]+"\""
                                                : qsTr("No icon selected")
                                        }

                                        // 复制按钮
                                        ToolButton {
                                            icon.name: "ic_fluent_copy_20_regular"
                                            onClicked: copyToClipboard(qmlCode.text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}