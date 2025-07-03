from PySide6.QtCore import QObject, Slot
from PySide6.QtWidgets import QApplication
from pathlib import Path
from RinUI import RinUIWindow, Theme
import sys


class IconLib(RinUIWindow):
    def __init__(self):
        super().__init__(Path(__file__).resolve().parent / "assets" / "qml" / "main.qml")
        self.setIcon((Path(__file__).parent / "assets" / "images" / "logo.png").as_posix())
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

    sys.exit(app.exec())
