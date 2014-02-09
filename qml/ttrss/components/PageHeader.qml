//Copyright Hauke Schade, 2012-2013
//
//This file is part of TTRss.
//
//TTRss is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
//Free Software Foundation, either version 2 of the License, or (at your option) any later version.
//TTRss is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//You should have received a copy of the GNU General Public License along with TTRss (on a Maemo/Meego system there is a copy
//in /usr/share/common-licenses. If not, see http://www.gnu.org/licenses/.

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Item{
    id: root

    property alias text: mainText.text
    property alias subtext: subText.text
    property alias logourl: logo.source
    property bool hasUpdateAction: false
    property bool busy: false

    signal updateActionActivated()

    height: Math.max(constant.headerHeight, textColumn.height)
    width: parent.width
    visible: text !== ""

    Image {
        id: background
        anchors.fill: parent
        source: "image://theme/color15-meegotouch-view-header-fixed"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    Image {
        id: logo
        sourceSize.width: constant.headerLogoHeight
        sourceSize.height: constant.headerLogoHeight
        width: source.length > 3 ? constant.headerLogoHeight : 0
        height: constant.headerLogoHeight
        visible: source.length > 3
        asynchronous: true

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
      //      right: mainText.left
            margins: constant.paddingLarge
        }
    }

    Column {
        id: textColumn
        anchors{
            verticalCenter: parent.verticalCenter
            left: logourl.length > 3 ? logo.right : parent.left
            right: updateAction.left
            margins: constant.paddingXLarge
        }
        Label {
            id: mainText
            font.pixelSize: constant.fontSizeXLarge
            color: "white"
            elide: Text.ElideRight
            maximumLineCount: 3
            width: parent.width

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mainText.maximumLineCount === 1)
                        mainText.maximumLineCount = 3
                    else
                        mainText.maximumLineCount = 1
                }
            }
        }
        Label {
            id: subText
            font.pixelSize: constant.fontSizeSmall
            color: "white"
            elide: Text.ElideRight
            maximumLineCount: 1
            visible: subText.text.length > 0
            width: parent.width
        }
    }

    Item {
        id: updateAction
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: constant.paddingLarge
        width: updateIcon.width
        height: updateIcon.height
        visible: hasUpdateAction || network.loading

        Image {
            id: updateIcon
            source: "image://theme/icon-m-toolbar-refresh"
            visible: hasUpdateAction && !network.loading && !busy
        }

        BusyIndicator {
            id: busyIndicator
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible: network.loading || busy
            running: network.loading || busy
            platformStyle: BusyIndicatorStyle { size: 'medium' }
        }

        MouseArea {
            enabled: !network.loading && !busy && hasUpdateAction
            anchors.fill: parent
            onClicked: {
                root.updateActionActivated()
            }
        }
    }
}