from PyQt5 import QtCore, QtGui, QtWidgets
from ReadConfig import ReadFileConfig # Get File config
from messagesBox import msgBox
from PyQt5.QtWidgets import *
from login import Ui_Login
from PyQt5 import *
from export import Ui_export # from export


class Ui_form_database(object):
    def setupUi(self, form_database):
        form_database.setObjectName("form_database")
        form_database.resize(278, 372)
        form_database.setMinimumSize(QtCore.QSize(278, 372))
        form_database.setMaximumSize(QtCore.QSize(278, 372))
        form_database.setWindowTitle("Database")
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("images/database-storage.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        form_database.setWindowIcon(icon)
        self.centralwidget = QtWidgets.QWidget(form_database)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.groupBox = QtWidgets.QGroupBox(self.centralwidget)
        self.groupBox.setStyleSheet("font: 10pt \"MS Shell Dlg 2\";")
        self.groupBox.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.groupBox.setObjectName("groupBox")
        self.gridLayout = QtWidgets.QGridLayout(self.groupBox)
        self.gridLayout.setObjectName("gridLayout")
        self.lineEdit_server = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_server.setObjectName("lineEdit_server")

        getCon = ReadFileConfig()

        self.lineEdit_server.setText(getCon.host)  # set ipaddress

        self.gridLayout.addWidget(self.lineEdit_server, 0, 0, 1, 1)
        self.lineEdit_dbname = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_dbname.setObjectName("lineEdit_dbname")

        self.lineEdit_dbname.setText(getCon.dbname)  # set dbname

        self.gridLayout.addWidget(self.lineEdit_dbname, 1, 0, 1, 1)
        self.lineEdit_port = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_port.setObjectName("lineEdit_port")

        self.lineEdit_port.setText(getCon.port)  # set port

        self.gridLayout.addWidget(self.lineEdit_port, 2, 0, 1, 1)
        self.lineEdit_user = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_user.setObjectName("lineEdit_user")

        self.lineEdit_user.setText(getCon.user)  # set user

        self.gridLayout.addWidget(self.lineEdit_user, 3, 0, 1, 1)
        self.lineEdit_password = QtWidgets.QLineEdit(self.groupBox)
        self.lineEdit_password.setObjectName("lineEdit_password")

        self.lineEdit_password.setText(getCon.password)  # set port

        self.lineEdit_password.setEchoMode(QLineEdit.EchoMode.Password)  # Set lineedit show password
        self.gridLayout.addWidget(self.lineEdit_password, 4, 0, 1, 1)
        self.gridLayout_2.addWidget(self.groupBox, 0, 0, 1, 2)
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(13)
        self.pushButton.setFont(font)
        self.pushButton.setObjectName("pushButton")

        self.gridLayout_2.addWidget(self.pushButton, 1, 0, 1, 1)
        self.pushButton_2 = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(13)
        self.pushButton_2.setFont(font)
        self.pushButton_2.setObjectName("pushButton_2")
        self.gridLayout_2.addWidget(self.pushButton_2, 1, 1, 1, 1)
        form_database.setCentralWidget(self.centralwidget)
        self.actionVersion_Postgres = QtWidgets.QAction(form_database)
        self.actionVersion_Postgres.setObjectName("actionVersion_Postgres")

        self.pushButton.clicked.connect(self.ConfirmDB)  # Login

        self.pushButton_2.clicked.connect(lambda: self.closescr(form_database))  # Login

        self.retranslateUi(form_database)
        QtCore.QMetaObject.connectSlotsByName(form_database)


    def ConfirmDB(self):
        ConnFile = ReadFileConfig()
        server = self.lineEdit_server.text()
        dbname = self.lineEdit_dbname.text()
        user = self.lineEdit_user.text()
        password = self.lineEdit_password.text()
        port = self.lineEdit_port.text()

        msg = msgBox()

        self.login = QtWidgets.QMainWindow()
        self.ui = Ui_Login()
        self.ui.setupUi(self.login)
        # print(server)



        # self.ui.lineEdit_username.setText("tttt")

        if ConnFile.writeFile(server, dbname, user, password, port) == True:
            msg.info('Connect Database Success!!!')
        else:
            msg.warning('ไม่สามารถเชื่อมต่อฐานข้อมูลได้')

    def closescr(self, form_database):
        form_database.hide()
        self.login = QtWidgets.QMainWindow()
        self.ui = Ui_Login()
        self.ui.setupUi(self.login)
        self.login.show()


    def retranslateUi(self, form_database):
        _translate = QtCore.QCoreApplication.translate
        self.groupBox.setTitle(_translate("form_database", "Connect Database"))
        self.lineEdit_server.setPlaceholderText(_translate("form_database", "IP Address"))
        self.lineEdit_dbname.setPlaceholderText(_translate("form_database", "Database Name"))
        self.lineEdit_port.setPlaceholderText(_translate("form_database", "Port"))
        self.lineEdit_user.setPlaceholderText(_translate("form_database", "User"))
        self.lineEdit_password.setPlaceholderText(_translate("form_database", "Password"))
        self.pushButton.setText(_translate("form_database", "Test Connect"))
        self.pushButton_2.setText(_translate("form_database", "Cancel"))
        self.actionVersion_Postgres.setText(_translate("form_database", "Version Postgres"))

