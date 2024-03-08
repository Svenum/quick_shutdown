import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kirigami 2.20 as Kirigami
import org.kde.config as KConfig  // KAuthorized.authorizeControlModule
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami

import org.kde.plasma.private.sessions 2.0 as Sessions

Item {
    id: fullRoot 

    implicitHeight: column.implicitHeight
    implicitWidth: column.implicitWidth

    Layout.preferredWidth: Kirigami.Units.gridUnit * 12
    Layout.preferredHeight: implicitHeight
    Layout.minimumWidth: Layout.preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumWidth: Layout.preferredWidth
    Layout.maximumHeight: Screen.height / 2

    Sessions.SessionManagement {
        id: sm
    }

    Sessions.SessionsModel {
        id: sessionsModel
    }

    ColumnLayout {
        id: column

        anchors.fill: parent
        spacing: 0

        UserListDelegate {
            id: currentUserItem
            text: root.displayedName
            subText: i18n("Current user")
            source: root.avatarIcon
            hoverEnabled: false
            visible: root.showUserInfo
        }

        PlasmaComponents3.ScrollView {
            id: scroll

            Layout.fillWidth: true
            Layout.fillHeight: true

            // HACK: workaround for https://bugreports.qt.io/browse/QTBUG-83890
            PlasmaComponents3.ScrollBar.horizontal.policy: PlasmaComponents3.ScrollBar.AlwaysOff

            ListView {
                id: userList
                model: sessionsModel

                focus: true
                interactive: true
                keyNavigationWraps: true

                delegate: UserListDelegate {
                    width: ListView.view.width

                    activeFocusOnTab: true

                    text: {
                        if (!model.session) {
                            return i18nc("Nobody logged in on that session", "Unused")
                        }

                        if (model.realName && root.showFullName) {
                            return model.realName
                        }

                        return model.name
                    }
                    source: model.icon
                    subText: {
                        if (!root.showTechnicalInfo) {
                            return ""
                        }

                        if (model.isTty) {
                            return i18nc("User logged in on console number", "TTY %1", model.vtNumber)
                        } else if (model.displayNumber) {
                            return i18nc("User logged in on console (X display number)", "on %1 (%2)", model.vtNumber, model.displayNumber)
                        }
                        return ""
                    }

                    KeyNavigation.up: index === 0 ? currentUserItem.nextItemInFocusChain() : userList.itemAtIndex(index - 1)
                    KeyNavigation.down: index === userList.count - 1 ? newSessionButton : userList.itemAtIndex(index + 1)

                    Accessible.description: i18nc("@action:button", "Switch to User %1", text)

                    onClicked: sessionsModel.switchUser(model.vtNumber, sessionsModel.shouldLock)
                }
            }
        }

        ActionListDelegate {
            id: newSessionButton
            text: i18nc("@action", "New Session")
            icon.name: "system-switch-user"
            visible: sessionsModel.canStartNewSession && root.showNewSessionButton

            KeyNavigation.up: userList.count > 0 ? userList.itemAtIndex(userList.count - 1) : currentUserItem.nextItemInFocusChain()
            KeyNavigation.down: lockScreenButton

            onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
        }

        ActionListDelegate {
            id: lockScreenButton
            text: i18nc("@action", "Lock Screen")
            icon.name: "system-lock-screen"
            visible: sm.canLock && root.showLockScreenButton
            onClicked: sm.lock()
        }

        ActionListDelegate {
            id: logOutButton
            text: i18nc("@action", "Log Out")
            icon.name: "system-log-out"
            visible: sm.canLogout && root.showLogOutButton

            KeyNavigation.up: lockScreenButton

            onClicked: sm.requestLogout(0)
        }

        ActionListDelegate {
            id: shutdownButton
            text: i18nc("@action", "Shutdown")
            icon.name: "system-shutdown"
            visible: sm.canShutdown && root.showShutdownButton
            onClicked: sm.requestShutdown(0)
        }

        ActionListDelegate {
            id: rebootButton
            text: i18nc("@action", "Reboot")
            icon.name: "system-reboot"
            visible: sm.canReboot && root.showRebootButton
            onClicked: sm.requestReboot(0)
        }

        ActionListDelegate {
            id: suspendButton
            text: i18nc("@action", "Suspend")
            icon.name: "system-suspend"
            visible: sm.canSuspend && root.showSuspendButton
            onClicked: sm.suspend()
        }

        ActionListDelegate {
            id: hibernateButton
            text: i18nc("@action", "Hibernate")
            icon.name: "system-hibernate"
            visible: sm.canSuspendThenHibernate && root.showHibernateButton
            onClicked: sm.suspendThenHibernate()
        }

        ActionListDelegate {
            id: leaveButton
            text: i18nc("Show a dialog with options to logout/shutdown/restart", "Log Out")
            icon.name: "system-leave"
            visible: sm.canLogout && root.showLeaveButton

            KeyNavigation.up: lockScreenButton

            onClicked: sm.requestLogout()
        }
    }

    Connections {
        target: root
        function onExpandedChanged() {
            if (root.expanded) {
                sessionsModel.reload();
            }
        }
    }
}
