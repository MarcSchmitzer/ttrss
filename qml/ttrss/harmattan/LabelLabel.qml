/*
 * This file is part of TTRss, a Tiny Tiny RSS Reader App
 * for MeeGo Harmattan and Sailfish OS.
 * Copyright (C) 2012–2015  Hauke Schade
 *
 * TTRss is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * TTRss is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with TTRss; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or see
 * http://www.gnu.org/licenses/.
 */

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {

    id: root
    property variant label

    visible: label !== undefined

    width: text.width + MyTheme.paddingSmall + MyTheme.paddingSmall
    height: text.height + MyTheme.paddingSmall
    color: root.label !== undefined ? root.label.bg_color : MyTheme.secondaryColor
    radius: MyTheme.paddingSmall
    anchors.margins: MyTheme.paddingSmall
    Text {
        anchors {
            verticalCenter: root.verticalCenter
            horizontalCenter: root.horizontalCenter
        }
        id: text
        text: root.label !== undefined ? root.label.caption : ""
        color: root.label !== undefined ? root.label.fg_color : MyTheme.primaryColor
        font.pixelSize: MyTheme.fontSizeExtraSmall
    }
    MouseArea {
        id: touchArea
        anchors.fill: parent
    }
}
