/*
 * SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QtControls

import org.kde.kirigami 2.20 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_showFace
    property bool cfg_showName
    property bool cfg_showFullName
    property alias cfg_showUserInfo: showUserInfo.checked
    property alias cfg_showNewSessionButton: showNewSessionButton.checked
    property alias cfg_showLockScreenButton: showLockScreenButton.checked
    property alias cfg_showLogOutButton: showLogOutButton.checked
    property alias cfg_showShutdownButton: showShutdownButton.checked
    property alias cfg_showRebootButton: showRebootButton.checked
    property alias cfg_showSuspendButton: showSuspendButton.checked
    property alias cfg_showHibernateButton: showHibernateButton.checked
    property alias cfg_showLeaveButton: showLeaveButton.checked

    Kirigami.FormLayout {
        QtControls.ButtonGroup {
            id: nameGroup
        }

        QtControls.RadioButton {
            id: showFullNameRadio

            Kirigami.FormData.label: i18nc("@title:label", "Username style:")

            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Full name (if available)")
            checked: cfg_showFullName
            onClicked: if (checked) cfg_showFullName = true;
        }

        QtControls.RadioButton {
            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Login username")
            checked: !cfg_showFullName
            onClicked: if (checked) cfg_showFullName = false;
        }


        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.ButtonGroup {
            id: layoutGroup
        }

        QtControls.RadioButton {
            id: showOnlyButton

            Kirigami.FormData.label: i18nc("@title:label", "Show:")

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Shutdown Button")
            checked: cfg_showShutdownButton &&!cfg_showName && !cfg_showFace
            onClicked: {
                if (checked) {
                    cfg_showShutdownButton = true;
                    cfg_showName = false;
                    cfg_showFace = false;
                }
            }
        }

        QtControls.RadioButton {
            id: showOnlyNameRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name")
            checked: cfg_showName && !cfg_showFace && !cfg_showShutdownButton
            onClicked: {
                if (checked) {
                    cfg_showShutdownButton = false;
                    cfg_showName = true;
                    cfg_showFace = false;
                }
            }
        }

        QtControls.RadioButton {
            id: showOnlyFaceRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "User picture")
            checked: !cfg_showName && cfg_showFace && !cfg_showShutdownButton
            onClicked: {
                if (checked) {
                    cfg_showShutdownButton = false;
                    cfg_showName = false;
                    cfg_showFace = true;
                }
            }
        }

        QtControls.RadioButton {
            id: showBothRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name and user picture")
            checked: cfg_showName && cfg_showFace && !cfg_showShutdownButton
            onClicked: {
                if (checked) {
                    cfg_showShutdownButton = false;
                    cfg_showName = true;
                    cfg_showFace = true;
                }
            }
        }


        Item {
            Kirigami.FormData.isSection: true
        }

        QtControls.CheckBox {
            id: showUserInfo
            Kirigami.FormData.label: i18nc("@title:label", "Buttons:")
            text: i18nc("@option:check", "Show Current Username")
            checked: true
        }
        QtControls.CheckBox {
            id: showNewSessionButton
            text: i18nc("@option:check", "Show the \"new Session\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showLockScreenButton
            text: i18nc("@option:check", "Show the \"Lock Screen\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showLogOutButton
            text: i18nc("@option:check", "Show the \"Logout\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showShutdownButton
            text: i18nc("@option:check", "Show the \"Shutdown\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showRebootButton
            text: i18nc("@option:check", "Show the \"Reboot\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showSuspendButton
            text: i18nc("@option:check", "Show the \"Suspend\" Button")
            checked: true
        }
        QtControls.CheckBox {
            id: showHibernateButton
            text: i18nc("@option:check", "Show the \"Hibernate\" Button")
            checked: false
        }
        QtControls.CheckBox {
            id: showLeaveButton
            text: i18nc("@option:check", "Show the \"Leave\" Button")
            checked: false
        }
    }
}
