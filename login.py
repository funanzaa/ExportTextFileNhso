from PyQt5.QtWidgets import *
from PyQt5 import QtCore, QtGui, QtWidgets
from ReadConfig import ReadFileConfig
from export import Ui_export
from form_connectDB import * # from connectDB
from messagesBox import *
from ReadDB import *


version = 'v.1.0.1'

class Ui_Login(object):
    def setupUi(self, Login):
        Login.setObjectName("Login")
        Login.setEnabled(True)
        Login.resize(687, 327)
        Login.setMinimumSize(QtCore.QSize(687, 327))
        Login.setMaximumSize(QtCore.QSize(687, 327))
        font = QtGui.QFont()
        font.setFamily("Segoe UI")
        font.setPointSize(16)
        font.setBold(True)
        font.setWeight(75)
        Login.setFont(font)
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("images/User.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        Login.setWindowIcon(icon)
        self.centralwidget = QtWidgets.QWidget(Login)
        self.centralwidget.setObjectName("centralwidget")
        self.groupBox = QtWidgets.QGroupBox(self.centralwidget)
        self.groupBox.setGeometry(QtCore.QRect(275, 11, 401, 281))
        self.groupBox.setObjectName("groupBox")
        self.gridLayout = QtWidgets.QGridLayout(self.groupBox)
        self.gridLayout.setObjectName("gridLayout")
        self.pushButton = QtWidgets.QPushButton(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(16)
        font.setBold(True)
        font.setWeight(75)
        self.pushButton.setFont(font)
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap("images/Pass.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton.setIcon(icon1)
        self.pushButton.setObjectName("pushButton")

        # self.pushButton.clicked.connect(self.login)  # Login
        self.pushButton.clicked.connect(lambda: self.login(Login))  # Login

        self.gridLayout.addWidget(self.pushButton, 2, 0, 1, 1)
        self.lineEdit_username = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_username.setObjectName("lineEdit_username")


        self.gridLayout.addWidget(self.lineEdit_username, 0, 0, 1, 1)
        self.lineEdit_password = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_password.setObjectName("lineEdit_password")
        self.lineEdit_password.setEchoMode(QLineEdit.EchoMode.Password)  # Set lineedit show password
        self.gridLayout.addWidget(self.lineEdit_password, 1, 0, 1, 1)
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(30, 60, 201, 181))
        self.label.setText("")
        self.label.setPixmap(QtGui.QPixmap("images/desktop_computers.png"))
        self.label.setScaledContents(True)
        self.label.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.label.setWordWrap(False)
        self.label.setObjectName("label")
        Login.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(Login)
        font = QtGui.QFont()
        font.setPointSize(14)
        self.statusbar.setFont(font)
        self.statusbar.setObjectName("statusbar")
        Login.setStatusBar(self.statusbar)

        self.retranslateUi(Login)
        QtCore.QMetaObject.connectSlotsByName(Login)

    def retranslateUi(self, Login):
        _translate = QtCore.QCoreApplication.translate
        Login.setWindowTitle(_translate("Login", "Login"))
        self.groupBox.setTitle(_translate("Login", "LogIn"))
        self.pushButton.setText(_translate("Login", "Login"))
        self.lineEdit_username.setPlaceholderText(_translate("Login", "Username"))
        self.lineEdit_password.setPlaceholderText(_translate("Login", "Password"))

    def login(self, Login):

        username = self.lineEdit_username.text()
        passwd = self.lineEdit_password.text()

        readDB = DataBase()
        nameUser = readDB.checkUser(username, passwd)

        # print(nameUser[0])
        # print(nameUser[1])

        if nameUser:
            self.form_export = QtWidgets.QMainWindow()
            self.ui = Ui_export()
            self.ui.setupUi(self.form_export)
            self.form_export.show()  # show login
            self.form_export.setWindowTitle("Export e-Claim {} ({})".format(version, nameUser[1]))

            self.form_export.show()

            self.ui.chkPermission(nameUser[0]) # send permission

            Login.close()


            # self.ui.label_show.setText("testsend") # test send form

        else:
            self.statusbar.showMessage("Username & Password is Wrong", 2000)






if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Login = QtWidgets.QMainWindow()
    ui = Ui_Login()
    ui.setupUi(Login)
    getCon = ReadFileConfig()
    if getCon.get_config() == False:
        form_connectDB = QtWidgets.QMainWindow()
        ui = Ui_form_database()
        ui.setupUi(form_connectDB)
        msg = msgBox()
        msg.warning('ไม่สามารถติดต่อฐานข้อมูลได้ กรุณาตรวจสอบการตั้งค่า หรือ ติดต่อผู้ดูแลระบบ')
        form_connectDB.show()
    else:
        Login.show()


    sys.exit(app.exec_())

