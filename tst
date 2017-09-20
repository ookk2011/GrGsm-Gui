#!/usr/bin/env python

import sys
import math
#import QTextBrowser
from PyQt4 import QtCore, QtGui


fname = "output.txt"

def file_len():
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

class Channel:
	def __init__(self, ARFCN, FREQ, MCC, MNC, LAC, CID, PWR):
		self.MCC = MCC
		self.MNC = MNC
		self.LAC = LAC
		self.ARFCN = ARFCN
		self.CID = CID
		self.FREQ = FREQ
		self.PWR = PWR



class Window(QtGui.QWidget):

	def __init__(self):
	        QtGui.QWidget.__init__(self)

		self.content = self.file_Content()

		self.right = QtGui.QFrame()
		self.right.setFrameShape(QtGui.QFrame.StyledPanel)

		pal = self.right.palette()
		pal.setColor(QtGui.QPalette.Background, QtGui.QColor(255,255,255))
		self.right.setPalette(pal)
		self.right.setAutoFillBackground(True)

		self.treeWidget = QtGui.QTreeWidget()
        	self.treeWidget.setHeaderHidden(True)
		self.addItems(self.treeWidget.invisibleRootItem())
		self.treeWidget.itemClicked.connect(self.handleChanged)

		self.text = QtGui.QLabel("", self.right)

		self.splitter1 = QtGui.QSplitter(QtCore.Qt.Horizontal)
		self.splitter1.addWidget(self.treeWidget)
       		self.splitter1.addWidget(self.right)

		self.layout = QtGui.QVBoxLayout()
		self.layout.addWidget(self.splitter1)
		self.setLayout(self.layout)

		self.setGeometry(100, 100, 800, 480)
        	self.setWindowTitle('GrGsm')


	def addItems(self, parent):
		
		column = 0
		channel_info = ['ARFCN','Frequency','CID','LAC','MCC','MNC','Power']
		channel_item = []


		for i in range(0, file_len()): 

######## Add TreeRoot
			parent_item = self.addParent(parent, column, "Channel " + str(i), "data Channel ")
			channel_item.append(parent_item)

			#QDesktopServices.openUrl(QUrl("google.de", QUrl.TolerantMode))
			
			Buffer_Channel = Channel(self.content[0 + (i*7)], self.content[1 + (i*7)], 
									self.content[2 + (i*7)], self.content[3 + (i*7)],
									self.content[4 + (i*7)], self.content[5 + (i*7)], self.content[6 + (i*7)])

			parent_item.setToolTip(column, "To locate BTS click here: \n\n" 
											"http://find-cell.mylnikov.org/#" + Buffer_Channel.MCC + "," + Buffer_Channel.MNC + "," + Buffer_Channel.LAC + "," + Buffer_Channel.CID)

######## Add TreeBranches
			for k in range(0, 7):
				item = self.addChild(channel_item[i], column, channel_info[k], channel_info[k] +": "+ self.content[k + (i*7)])
				
				if k==0:
					item.setToolTip(column, "Absolute Radio Frequency Channel Number:\n\n" + Buffer_Channel.ARFCN)
				elif k==1:
					item.setToolTip(column, "Frequency:\n\n" + Buffer_Channel.FREQ)
				elif k==2:
					item.setToolTip(column, "Cell Identification:\n\n" + Buffer_Channel.CID)
				elif k==3:
					item.setToolTip(column, "Location Area:\n\n" + Buffer_Channel.LAC)
				elif k==4:
					item.setToolTip(column, "Mobile Country Code:\n\n" + Buffer_Channel.MCC)
				elif k==5:
					item.setToolTip(column, "Mobile Network Code:\n\n" + Buffer_Channel.MNC +
							"\n\nLegende:\n01: Telekom Deutschland\n02: Vodafone\n03: Telefonica (ehem. E-Plus)\n07: Telefonica (ehem. O2)\n10: DB Telematic")
				elif k==6:
					item.setToolTip(column, "Power:\n\n" + Buffer_Channel.PWR)		

			#self.addChild(channel_item, column, 'Frequency', 'data Frequency')
			#self.addChild(channel_item, column, 'CID', 'data CID')
			#self.addChild(channel_item, column, 'LAC', 'data LAC')
			#self.addChild(channel_item, column, 'MCC', 'data MCC')
			#self.addChild(channel_item, column, 'MNC', 'data MNC')
			#self.addChild(channel_item, column, 'Power', 'data Power')


			i += 1


    	def addParent(self, parent, column, title, data):
        	item = QtGui.QTreeWidgetItem(parent, [title])
        	item.setData(column, QtCore.Qt.UserRole, data)
        	item.setChildIndicatorPolicy(QtGui.QTreeWidgetItem.ShowIndicator)
        	item.setExpanded (False)
        	return item

   	def addChild(self, parent, column, title, data):
      	 	item = QtGui.QTreeWidgetItem(parent, [title])
      	 	item.setData(column, 0, data)
		item.setSelected (False)
        	return item

	def handleChanged(self, item, column):
		if item.isSelected():	
			QtGui.QLabel.clear(self.text)
			self.text = QtGui.QLabel(item.toolTip(column),self.right)
			QtGui.QLabel.show(self.text)
			#print item.text(column)

	def file_Content(self):	
		with open(fname) as f:
    			content = f.readlines()
		content = [x.strip("\n") for x in content] 
		content_temp = []
		for i in range(0, len(content)):
			content_temp = content_temp + str(content[i]).split(", ")
		content = content_temp
		return content




if __name__ == "__main__":

	app = QtGui.QApplication(sys.argv)
	window = Window()
	window.show()
	sys.exit(app.exec_())
