//Copyright Hauke Schade, 2012-2014
//
//This file is part of TTRss.
//
//TTRss is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
//Free Software Foundation, either version 2 of the License, or (at your option) any later version.
//TTRss is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//You should have received a copy of the GNU General Public License along with TTRss (on a Maemo/Meego system there is a copy
//in /usr/share/common-licenses. If not, see http://www.gnu.org/licenses/.

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: feeditemsPage
    property variant feed

    title: feed.title

    Component.onCompleted: {
        feedItems.feed = feeditemsPage.feed
        feedItems.hasMoreItems = false
        feedItems.continuation = 0
        feedItems.clear()
        var ttrss = rootWindow.getTTRSS()
        ttrss.setShowAll(settings.showAll)
        feedItems.update()
        // FIXME workaround for https://bugs.launchpad.net/bugs/1404884
        pullToRefresh.enabled = true
    }

    head {
        sections {
            model: [ qsTr("Unread"), qsTr("All") ]
            selectedIndex: settings.showAll ? 1 : 0
            onSelectedIndexChanged: {
                var ttrss = rootWindow.getTTRSS()
                var showAll = (feeditemsPage.head.sections.selectedIndex == 1)
                if (showAll != settings.showAll) {
                    ttrss.setShowAll(showAll)
                    settings.showAll = showAll
                    feedItems.continuation = 0
                    feedItems.hasMoreItems = false
                    feedItems.clear()
                    feedItems.update()
                }
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: feedItems

        PullToRefresh {
            id: pullToRefresh
            enabled: false
            onRefresh: feedItems.update()
            refreshing: network.loading
        }

        /* TODO
        PullDownMenu {
//            AboutItem {}
//            SettingsItem {}
            MenuItem {
                text: qsTr("Update")
                enabled: !network.loading
                onClicked: {
                    feedItems.continuation = 0
                    feedItems.hasMoreItems = false
                    feedItems.clear()
                    feedItems.update()
                }
            }
            ToggleShowAllItem {
                onUpdateView: {
                    feedItems.continuation = 0
                    feedItems.hasMoreItems = false
                    feedItems.clear()
                    feedItems.update()
                }
            }
            MenuItem {
                text: qsTr('Mark all read')
                onClicked: {
                    feedItems.catchUp()
                }
            }
        }
        */

        section {
            property: 'date'

            delegate: ListItem.Caption {
                text: section
            }
        }

        delegate: FeedItemDelegate {
            onClicked: {
                feedItems.selectedIndex = index
                pageStack.push(Qt.resolvedUrl("FeedItemSwipe.qml"), {
                    model: feedItems,
                    currentIndex: index,
                    isCat: feed.isCat
                })
            }
        }

        Label {
            visible: listView.count == 0
            text: network.loading ?
                      qsTr("Loading") :
                      rootWindow.showAll ? qsTr("No items in feed") : qsTr("No unread items in feed")
        }
        ActivityIndicator {
            running: network.loading
            anchors.centerIn: parent
            onRunningChanged: {
                /* We want to show this activity indicator just for the first
                 * time, as a workaround for
                 * https://bugs.launchpad.net/bugs/1404884. So, once the
                 * initial loading has completed, we disable this item */
                if (!running) visible = false
            }
        }
        Scrollbar {
            flickableItem: listView
        }
    }

    function showFeed(feedModel) {
        if (feedModel != null) {
            pageStack.push(Qt.resolvedUrl("FeedItems.qml"), {
                feed: feedModel
            })
        }
    }
}
