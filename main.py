#!/usr/bin/env python
from PyQt4 import QtCore, QtGui, QtDeclarative
import optparse
import sys
import os

parser = optparse.OptionParser()

(options, args) = parser.parse_args(sys.argv)

app = QtGui.QApplication(sys.argv)

view = QtDeclarative.QDeclarativeView()
def sorter(a, b):
    n1 = ""
    n2 = ""
    for c in a:
        try:
            n1 += str(int(c))
        except:
            break
    for c in b:
        try:
            n2 += str(int(c))
        except:
            break
    try:
        return int(n1) > int(n2)
    except:
        return a > b

files = sorted(
    filter(
        lambda x:x.split('.')[-1].lower() in ['jpg', 'png', 'gif'],
        os.listdir(".")
    ),
    sorter
)

print files

view.rootContext().setContextProperty("slideFiles", files)
view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
view.setSource(QtCore.QUrl("main.qml"))
view.showFullScreen()
print "exec"
sys.exit(app.exec_())
