from PyQt5.QtWidgets import *
from PyQt5 import QtCore, QtGui, QtWidgets
from export import Ui_export # from export
from form_connectDB import Ui_form_database # from connectDB
import sys
from login import Ui_Login
from ReadConfig import ReadFileConfig
from export import Ui_export


class AppWindow(QMainWindow, Ui_Login):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.show()

        self.pushButton.clicked.connect(self.Login)  # Login

        # check connecting database False
        getCon = ReadFileConfig()
        if getCon.get_config() == False:
            # self.pushButton.setDisabled(True)
            self.ShowFormConnectDB()

    def ShowFormConnectDB(self):
        self.form_connectDB = QtWidgets.QMainWindow()
        self.ui = Ui_form_database()
        self.ui.setupUi(self.form_connectDB)
        QMessageBox.warning(self, "Waring", "ไม่สามารถติดต่อฐานข้อมูลได้ กรุณาติดต่อผู้ดูแลระบบ")
        self.form_connectDB.show()




    # def Login(self):
    #     username = self.lineEdit_username.text()
    #     passwd = self.lineEdit_password.text()
    #
    #     if username == 'admin' and passwd == 'demo':
    #         self.window = QtWidgets.QMainWindow()
    #         self.ui = Ui_export()
    #         self.ui.setupUi(self.window)
    #         self.window.show()
    #         self.hide()
    #     else:
    #         self.statusbar.showMessage("Username & Password is Wrong", 2000)

    def Login(self):

        username = self.lineEdit_username.text()
        passwd = self.lineEdit_password.text()

        if username == 'admin' and passwd == 'demo':
            self.form_export = QtWidgets.QMainWindow()
            self.ui = Ui_export()

            self.ui.setupUi(self.form_export)


            self.form_export.show() # show login

            # self.ui.label_show.setText("testsend") # test send form



            self.hide() # hide login


        else:
            self.statusbar.showMessage("Username & Password is Wrong", 2000)


app = QApplication(sys.argv)
Note = AppWindow()
sys.exit(app.exec())