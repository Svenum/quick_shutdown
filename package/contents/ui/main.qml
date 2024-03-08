/*
 *  SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0
import org.kde.coreaddons 1.0 as KCoreAddons // kuser
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore

import org.kde.plasma.private.sessions 2.0 as Sessions

PlasmoidItem {
    id: root

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)


    readonly property string displayedName: showFullName ? kuser.fullName : kuser.loginName
    readonly property bool showFullName: Plasmoid.configuration.showFullName

    readonly property bool showFace: Plasmoid.configuration.showFace
    readonly property bool showName: Plasmoid.configuration.showName
    readonly property string avatarIcon: kuser.faceIconUrl.toString()

    // Buttons
    readonly property bool showUserInfo: Plasmoid.configuration.showUserInfo
    readonly property bool showNewSessionButton: Plasmoid.configuration.showNewSessionButton
    readonly property bool showLockScreenButton: Plasmoid.configuration.showLockScreenButton
    readonly property bool showLogOutButton: Plasmoid.configuration.showLogOutButton
    readonly property bool showShutdownButton: Plasmoid.configuration.showShutdownButton
    readonly property bool showRebootButton: Plasmoid.configuration.showRebootButton
    readonly property bool showSuspendButton: Plasmoid.configuration.showSuspendButton
    readonly property bool showHibernateButton: Plasmoid.configuration.showHibernateButton
    readonly property bool showLeaveButton: Plasmoid.configuration.showLeaveButton

    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 12

    toolTipTextFormat: Text.StyledText
    toolTipSubText: i18n("You are logged in as <b>%1</b>", displayedName)

    // revert to the Plasmoid icon if no face given
    Plasmoid.icon: kuser.faceIconUrl.toString() || (inPanel ? "system-switch-user-symbolic" : "preferences-system-users" )

    KCoreAddons.KUser {
        id: kuser
    }

    compactRepresentation: MouseArea {
        id: compactRoot

        // Taken from DigitalClock to ensure uniform sizing when next to each other
        readonly property bool tooSmall: Plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= Kirigami.Theme.smallFont.pixelSize

        Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
        Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
        Layout.preferredWidth: isVertical ? -1 : Layout.minimumWidth

        Layout.minimumHeight: isVertical ? label.height : Kirigami.Theme.smallFont.pixelSize
        Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
        Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Units.iconSizes.sizeForLabels * 2

        property bool wasExpanded
        onPressed: wasExpanded = root.expanded
        onClicked: root.expanded = !wasExpanded

        Row {
            id: compactRow

            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
              id: shutdownIcon

              source: "system-shutdown"
              
              anchors.verticalCenter: parent.verticalCenter
              height: compactRoot.height - Math.round(Kirigami.Units.smallSpacing / 2)
              width: height

              visible: root.showShutdownButton
            }

            KirigamiComponents.Avatar {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                height: compactRoot.height - Math.round(Kirigami.Units.smallSpacing / 2)
                width: height

                name: root.displayedName

                source: visible ? root.avatarIcon : ""
                visible: root.showFace
            }

            PlasmaComponents3.Label {
                id: label

                width: root.isVertical ? compactRoot.width : contentWidth
                height: root.isVertical ? contentHeight : compactRoot.height

                text: root.displayedName
                textFormat: Text.PlainText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                fontSizeMode: root.isVertical ? Text.HorizontalFit : Text.VerticalFit
                font.pixelSize: tooSmall ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridUnit * 2)
                minimumPointSize: Kirigami.Theme.smallFont.pointSize
                visible: root.showName
            }
        }
    }

    fullRepresentation: FullRepresentation {}
}
