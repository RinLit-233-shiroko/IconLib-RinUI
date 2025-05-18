from PySide6.QtCore import QObject, Slot
from PySide6.QtWidgets import QApplication
from RinUI import RinUIWindow, BackdropEffect, Theme
import sys
# from PySide6.QtCore import


class IconLib(RinUIWindow):
    def __init__(self):
        super().__init__("assets/qml/main.qml")
        self.setIcon("assets/images/logo.png")
        # register backend
        self.backend = IconLibBackend()
        self.engine.rootContext().setContextProperty("Backend", self.backend)


class IconLibBackend(QObject):
    @Slot(str)
    def copyToClipboard(self, text: str):
        QApplication.clipboard().setText(text)


if __name__ == "__main__":
    app = QApplication()
    icon_lib_main = IconLib()
    icon_lib_main.setTheme(Theme.Auto)
    icon_lib_main.setBackdropEffect(BackdropEffect.Mica)

    sys.exit(app.exec())
