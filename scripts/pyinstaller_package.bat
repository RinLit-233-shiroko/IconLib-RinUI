cd ../
.venv\Scripts\pyinstaller.exe -w --icon=assets/images/logo.ico --name=IconLibrary --add-data "assets;assets" --contents-directory="." main.py