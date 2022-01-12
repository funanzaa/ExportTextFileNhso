import time

from PyQt5 import *
import os
import sys
from PyQt5.QtWidgets import *
from messagesBox import msgBox
from ExportFile import DataBase

from PyQt5.QtWidgets import *





class Ui_export(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        # MainWindow.setWindowTitle("8888888888")
        MainWindow.resize(915, 536)
        MainWindow.setMinimumSize(QtCore.QSize(915, 536))
        MainWindow.setMaximumSize(QtCore.QSize(915, 536))
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("images/logo.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        MainWindow.setWindowIcon(icon)
        MainWindow.setLocale(QtCore.QLocale(QtCore.QLocale.English, QtCore.QLocale.UnitedStates))
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.label_show = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(17)
        font.setBold(True)
        font.setWeight(75)
        self.label_show.setFont(font)
        self.label_show.setText("")
        self.label_show.setObjectName("label_show")
        self.gridLayout_2.addWidget(self.label_show, 2, 0, 1, 20)
        self.dateEdit_from = QtWidgets.QDateEdit(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.dateEdit_from.setFont(font)
        self.dateEdit_from.setLocale(QtCore.QLocale(QtCore.QLocale.English, QtCore.QLocale.UnitedStates))
        self.dateEdit_from.setCalendarPopup(True)
        self.dateEdit_from.setCurrentSectionIndex(0)
        self.dateEdit_from.setTimeSpec(QtCore.Qt.LocalTime)
        self.dateEdit_from.setObjectName("dateEdit_from")

        self.dateEdit_from.setDateTime(QtCore.QDateTime.currentDateTime())  # set date from crrent

        self.gridLayout_2.addWidget(self.dateEdit_from, 0, 8, 1, 1)
        self.label = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.gridLayout_2.addWidget(self.label, 0, 7, 1, 1)
        self.groupBox = QtWidgets.QGroupBox(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.groupBox.setFont(font)
        self.groupBox.setObjectName("groupBox")
        self.gridLayout = QtWidgets.QGridLayout(self.groupBox)
        self.gridLayout.setObjectName("gridLayout")
        self.checkBox = QtWidgets.QCheckBox(self.groupBox)
        self.checkBox.setObjectName("checkBox")

        self.checkBox.stateChanged.connect(self.All_Item_selected)  # checked All

        self.gridLayout.addWidget(self.checkBox, 0, 0, 1, 1)
        self.checkBox_ins = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_ins.setFont(font)
        self.checkBox_ins.setObjectName("checkBox_ins")
        self.gridLayout.addWidget(self.checkBox_ins, 1, 0, 1, 1)
        self.checkBox_idx = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_idx.setFont(font)
        self.checkBox_idx.setObjectName("checkBox_idx")
        self.gridLayout.addWidget(self.checkBox_idx, 1, 1, 1, 1)
        self.checkBox_pat = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_pat.setFont(font)
        self.checkBox_pat.setObjectName("checkBox_pat")
        self.gridLayout.addWidget(self.checkBox_pat, 2, 0, 1, 1)
        self.checkBox_iop = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_iop.setFont(font)
        self.checkBox_iop.setObjectName("checkBox_iop")
        self.gridLayout.addWidget(self.checkBox_iop, 2, 1, 1, 1)
        self.checkBox_opd = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_opd.setFont(font)
        self.checkBox_opd.setObjectName("checkBox_opd")
        self.gridLayout.addWidget(self.checkBox_opd, 3, 0, 1, 1)
        self.checkBox_cht = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_cht.setFont(font)
        self.checkBox_cht.setObjectName("checkBox_cht")
        self.gridLayout.addWidget(self.checkBox_cht, 3, 1, 1, 1)
        self.checkBox_orf = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_orf.setFont(font)
        self.checkBox_orf.setObjectName("checkBox_orf")
        self.gridLayout.addWidget(self.checkBox_orf, 4, 0, 1, 1)
        self.checkBox_cha = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_cha.setFont(font)
        self.checkBox_cha.setObjectName("checkBox_cha")
        self.gridLayout.addWidget(self.checkBox_cha, 4, 1, 1, 1)
        self.checkBox_odx = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_odx.setFont(font)
        self.checkBox_odx.setObjectName("checkBox_odx")
        self.gridLayout.addWidget(self.checkBox_odx, 5, 0, 1, 1)
        self.checkBox_aer = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_aer.setFont(font)
        self.checkBox_aer.setObjectName("checkBox_aer")
        self.gridLayout.addWidget(self.checkBox_aer, 5, 1, 1, 1)
        self.checkBox_oop = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_oop.setFont(font)
        self.checkBox_oop.setObjectName("checkBox_oop")
        self.gridLayout.addWidget(self.checkBox_oop, 6, 0, 1, 1)
        self.checkBox_adp = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(13)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_adp.setFont(font)
        self.checkBox_adp.setObjectName("checkBox_adp")
        self.gridLayout.addWidget(self.checkBox_adp, 6, 1, 1, 1)
        self.checkBox_ipd = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_ipd.setFont(font)
        self.checkBox_ipd.setObjectName("checkBox_ipd")
        self.gridLayout.addWidget(self.checkBox_ipd, 7, 0, 1, 1)
        self.checkBox_lvd = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_lvd.setFont(font)
        self.checkBox_lvd.setObjectName("checkBox_lvd")
        self.gridLayout.addWidget(self.checkBox_lvd, 7, 1, 1, 1)
        self.checkBox_irf = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_irf.setFont(font)
        self.checkBox_irf.setObjectName("checkBox_irf")
        self.gridLayout.addWidget(self.checkBox_irf, 8, 0, 1, 1)
        self.checkBox_dru = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(14)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_dru.setFont(font)
        self.checkBox_dru.setObjectName("checkBox_dru")
        self.gridLayout.addWidget(self.checkBox_dru, 8, 1, 1, 1)
        self.checkBox_labfu = QtWidgets.QCheckBox(self.groupBox)
        font = QtGui.QFont()
        font.setFamily("TH SarabunPSK")
        font.setPointSize(13)
        font.setBold(True)
        font.setWeight(75)
        self.checkBox_labfu.setFont(font)
        self.checkBox_labfu.setObjectName("checkBox_labfu")
        self.gridLayout.addWidget(self.checkBox_labfu, 9, 1, 1, 1)
        self.gridLayout_2.addWidget(self.groupBox, 1, 0, 1, 20)
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.gridLayout_2.addWidget(self.label_2, 0, 9, 1, 1)
        self.dateEdit_to = QtWidgets.QDateEdit(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.dateEdit_to.setFont(font)
        self.dateEdit_to.setLocale(QtCore.QLocale(QtCore.QLocale.English, QtCore.QLocale.UnitedStates))
        self.dateEdit_to.setCalendarPopup(True)
        self.dateEdit_to.setObjectName("dateEdit_to")

        self.dateEdit_to.setDateTime(QtCore.QDateTime.currentDateTime())  # set date from crrent

        self.gridLayout_2.addWidget(self.dateEdit_to, 0, 10, 1, 1)
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Segoe UI Black")
        font.setPointSize(9)
        font.setBold(True)
        font.setWeight(75)
        self.pushButton.setFont(font)
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap("images/outline_file_upload_black_48dp.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.pushButton.setIcon(icon1)
        self.pushButton.setIconSize(QtCore.QSize(50, 20))
        self.pushButton.setAutoDefault(False)
        self.pushButton.setDefault(True)
        self.pushButton.setObjectName("pushButton")

        # self.pushButton.clicked.connect(self.openSaveDialog) # button export

        self.pushButton.clicked.connect(lambda: self.openSaveDialog(True))  # button export

        self.gridLayout_2.addWidget(self.pushButton, 0, 11, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 915, 26))
        self.menubar.setObjectName("menubar")

        #####  menu ##########
        self.menu = QtWidgets.QMenu(self.menubar)
        self.menu.setObjectName("menu")
        MainWindow.setMenuBar(self.menubar)
        self.action = QtWidgets.QAction(MainWindow)
        icon2 = QtGui.QIcon()
        icon2.addPixmap(QtGui.QPixmap("images/user-16.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.action.setIcon(icon2)
        self.action.setObjectName("action")
        self.menu.addAction(self.action)
        self.menubar.addAction(self.menu.menuAction())
        ##############


        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def chkstatusbox(self):
        if self.checkBox_opd.isChecked() or self.checkBox_pat.isChecked() or \
                self.checkBox_ins.isChecked() or self.checkBox_orf.isChecked() or\
                self.checkBox_ipd.isChecked() or self.checkBox_odx.isChecked() or self.checkBox_oop.isChecked() or\
                self.checkBox_dru.isChecked() or self.checkBox_irf.isChecked() or self.checkBox_idx.isChecked() or\
                self.checkBox_iop.isChecked() or self.checkBox_cht.isChecked() or self.checkBox_cha.isChecked() or\
                self.checkBox_aer.isChecked() or self.checkBox_adp.isChecked() or self.checkBox_lvd.isChecked() or\
                self.checkBox_labfu.isChecked():
            return True

    def openSaveDialog(self, status):

        msg = msgBox()
        # print(status)

        if status == True and self.chkstatusbox():
            widget = QWidget()
            dialog = QFileDialog()
            dir = dialog.getExistingDirectory(widget, 'Select directory')
        else:
            msg.info("Please Choose File Export")

        dateEdit_from = self.dateEdit_from.date()
        dateFrom = dateEdit_from.toPyDate()
        dateEdit_to = self.dateEdit_to.date()
        dateto = dateEdit_to.toPyDate()

        exportFile = DataBase()

        nameFile = []
        status = False

        if self.checkBox_opd.isChecked():
            re_export = exportFile.export('OPD', dateFrom, dateto, dir)
            nameFile.append('OPD')
            status = re_export

        if self.checkBox_pat.isChecked():
            re_export = exportFile.export('PAT', dateFrom, dateto, dir)
            nameFile.append('PAT')
            status = re_export

        if self.checkBox_ins.isChecked():
            re_export = exportFile.export('INS', dateFrom, dateto, dir)
            nameFile.append('INS')
            status = re_export

        if self.checkBox_orf.isChecked():
            re_export = exportFile.export('ORF', dateFrom, dateto, dir)
            nameFile.append('ORF')
            status = re_export

        if self.checkBox_ipd.isChecked():
            re_export = exportFile.export('IPD', dateFrom, dateto, dir)
            nameFile.append('IPD')
            status = re_export

        if self.checkBox_odx.isChecked():
            re_export = exportFile.export('ODX', dateFrom, dateto, dir)
            nameFile.append('ODX')
            status = re_export

        if self.checkBox_oop.isChecked():
            re_export = exportFile.export('OOP', dateFrom, dateto, dir)
            nameFile.append('OOP')
            status = re_export

        if self.checkBox_dru.isChecked():
            re_export = exportFile.export('DRU', dateFrom, dateto, dir)
            nameFile.append('DRU')
            status = re_export

        if self.checkBox_irf.isChecked():
            re_export = exportFile.export('IRF', dateFrom, dateto, dir)
            nameFile.append('IRF')
            status = re_export

        if self.checkBox_idx.isChecked():
            re_export = exportFile.export('IDX', dateFrom, dateto, dir)
            nameFile.append('IDX')
            status = re_export

        if self.checkBox_iop.isChecked():
            re_export = exportFile.export('IOP', dateFrom, dateto, dir)
            nameFile.append('IOP')
            status = re_export

        if self.checkBox_cht.isChecked():
            re_export = exportFile.export('CHT', dateFrom, dateto, dir)
            nameFile.append('CHT')
            status = re_export

        if self.checkBox_cha.isChecked():
            re_export = exportFile.export('CHA', dateFrom, dateto, dir)
            nameFile.append('CHA')
            status = re_export

        if self.checkBox_aer.isChecked():
            re_export = exportFile.export('AER', dateFrom, dateto, dir)
            nameFile.append('AER')
            status = re_export

        if self.checkBox_adp.isChecked():
            re_export = exportFile.export('ADP', dateFrom, dateto, dir)
            nameFile.append('ADP')
            status = re_export

        if self.checkBox_lvd.isChecked():
            re_export = exportFile.export('LVD', dateFrom, dateto, dir)
            nameFile.append('LVD')
            status = re_export

        if self.checkBox_labfu.isChecked():
            re_export = exportFile.export('LABFU', dateFrom, dateto, dir)
            nameFile.append('LABFU')
            status = re_export

        if status:
            msg.info("Export {} Success!! \n{} ".format(nameFile, dir))



    def chkPermission(self, text):

        if text == '1': # check permission admin
            _translate = QtCore.QCoreApplication.translate
            self.menu.setTitle(_translate("MainWindow", "Setting"))
            self.action.setText(_translate("MainWindow", "User"))



    def clearText(self):
        self.label_show.clear()

    def All_Item_selected(self):
        if self.checkBox.isChecked():
            self.checkBox.setText('Not select All')
            self.checkBox_ins.setChecked(True)
            self.checkBox_pat.setChecked(True)
            self.checkBox_opd.setChecked(True)
            self.checkBox_orf.setChecked(True)
            self.checkBox_odx.setChecked(True)
            self.checkBox_oop.setChecked(True)
            self.checkBox_ipd.setChecked(True)
            self.checkBox_irf.setChecked(True)
            self.checkBox_idx.setChecked(True)
            self.checkBox_iop.setChecked(True)
            self.checkBox_cht.setChecked(True)
            self.checkBox_cha.setChecked(True)
            self.checkBox_aer.setChecked(True)
            self.checkBox_adp.setChecked(True)
            self.checkBox_lvd.setChecked(True)
            self.checkBox_dru.setChecked(True)
            self.checkBox_labfu.setChecked(True)
        else:
            self.checkBox.setText('Select All')
            self.checkBox_ins.setChecked(False)
            self.checkBox_pat.setChecked(False)
            self.checkBox_opd.setChecked(False)
            self.checkBox_orf.setChecked(False)
            self.checkBox_odx.setChecked(False)
            self.checkBox_oop.setChecked(False)
            self.checkBox_ipd.setChecked(False)
            self.checkBox_irf.setChecked(False)
            self.checkBox_idx.setChecked(False)
            self.checkBox_iop.setChecked(False)
            self.checkBox_cht.setChecked(False)
            self.checkBox_cha.setChecked(False)
            self.checkBox_aer.setChecked(False)
            self.checkBox_adp.setChecked(False)
            self.checkBox_lvd.setChecked(False)
            self.checkBox_dru.setChecked(False)
            self.checkBox_labfu.setChecked(False)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        # MainWindow.setWindowTitle(_translate("MainWindow", "Export e-Claim v.1.0.0"))
        self.dateEdit_from.setDisplayFormat(_translate("MainWindow", "dd-MM-yyyy"))
        self.label.setText(_translate("MainWindow", "From"))
        self.groupBox.setTitle(_translate("MainWindow", "16 File"))
        self.checkBox.setText(_translate("MainWindow", "Select All"))
        self.checkBox_ins.setText(_translate("MainWindow", "INS แฟ้มข้อมูลผู้มีสิทธิการรักษาพยาบาล "))
        self.checkBox_idx.setText(_translate("MainWindow", "IDX มาตรฐานแฟ้มข้อมูลวินิจฉัยโรคผู้ป่วยใน"))
        self.checkBox_pat.setText(_translate("MainWindow", "PAT แฟ้มข้อมูลผู้ป่วยกลาง "))
        self.checkBox_iop.setText(_translate("MainWindow", "IOP แฟ้มข้อมูลหัตถการผู้ป่วยใน"))
        self.checkBox_opd.setText(_translate("MainWindow", "OPD แฟ้มข้อมูลการมารับบริการผู้ป่วยนอก"))
        self.checkBox_cht.setText(_translate("MainWindow", "CHT แฟ้มข้อมูลการเงิน (แบบสรุป)"))
        self.checkBox_orf.setText(_translate("MainWindow", "ORF แฟ้มข้อมูลผู้ป่วยนอกที่ต้องส่งต่อ"))
        self.checkBox_cha.setText(_translate("MainWindow", "CHA แฟ้มข้อมูลการเงิน (แบบรายละเอียด) "))
        self.checkBox_odx.setText(_translate("MainWindow", "ODX แฟ้มข้อมูลวินิจฉัยโรคผู้ป่วยนอก "))
        self.checkBox_aer.setText(_translate("MainWindow", "AER แฟ้มข้อมูลอุบัติเหตุ ฉุกเฉิน และรับส่งเพื่อรักษา "))
        self.checkBox_oop.setText(_translate("MainWindow", "OOP แฟ้มข้อมูลหัตถการผู้ป่วยนอก "))
        self.checkBox_adp.setText(
            _translate("MainWindow", "ADP แฟ้มข้อมูลค่าใช้จ่ายเพิ่ม และบริการที่ยังไม่ได้จัดหมวด "))
        self.checkBox_ipd.setText(_translate("MainWindow", "IPD แฟ้มข้อมูลผู้ป่วยใน "))
        self.checkBox_lvd.setText(_translate("MainWindow", "LVD แฟ้มข้อมูลกรณีที่ผู้ป่วยมีการลากลับบ้าน (Leave day) "))
        self.checkBox_irf.setText(_translate("MainWindow", "IRF แฟ้มข้อมูลผู้ป่วยในที่ต้องส่งต่อ"))
        self.checkBox_dru.setText(_translate("MainWindow", "DRU แฟ้มข้อมูลการใช้ยา"))
        self.checkBox_labfu.setText(
            _translate("MainWindow", "LABFU แฟ้มข้อมูลการตรวจทางห้องปฏิบัติการของผู้ป่วยโรคเรื้อรัง"))
        self.label_2.setText(_translate("MainWindow", "To"))
        self.dateEdit_to.setDisplayFormat(_translate("MainWindow", "dd-MM-yyyy"))
        self.pushButton.setText(_translate("MainWindow", "Export"))

        ####  menu #######
        # self.menu.setTitle(_translate("MainWindow", "Setting"))
        # self.action.setText(_translate("MainWindow", "User"))
