![](https://static.wixstatic.com/media/e5b7d4_f67ff8c629844818a6e3e43550cb1e17~mv2.png/v1/fill/w_348,h_122,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/Original%20on%20Transparent.png)

ITSM-NG is a GLPI fork with the objective of offering a strong community component and relevant technological choices.

# Some Links

  * [Website](https://www.itsm-ng.com)
  * [Github](https://github.com/itsmng)
  * [Wiki](https://wiki.itsm-ng.org)

# Introduction

This is a cross platform application building in Flutter. This application allow to the list, create, modify, show more information of a ticket or a computer.

# Setup the application

To configure the ITSM-NG mobile application, please refer to our documentation : [Android application](https://wiki.itsm-ng.org/third-party/android-app/).

# Usage

Set up your the application with your settings (URL, Token...) and click on `Send`.

![](assets/android-app_compilation.gif)

# Prerequisites

Here is teh list of the different dependencies and their versions useful for the application.

* Flutter: 3.7.0-23.0.pre.23 • channel master
* Dart: 3.0.0 (build 3.0.0-136.0.dev)
* The version and build number: 1.0.0+1
* Java: OpenJDK Runtime Environment (build 11.0.13+0-b1751.21-8125866)

* flutter:
    * sdk: flutter

* cupertino_icons: ^1.0.2
* http: ^0.13.5
* rflutter_alert: ^2.0.4
* charts_flutter: ^0.12.0
* regexed_validator: ^2.0.0+1
* shared_preferences: ^2.0.16
* intl: ^0.17.0
* flutter_speed_dial: ^6.2.0
* duration_picker: ^1.1.1
* flutter_localizations:
* sdk: flutter
* flutter_launcher_icons: ^0.13.0
* rename: ^2.1.1

# File structure
This is a brieve description of the application structure in the main folder.

* :file_folder: lib
    * :file_folder: api
        * :page_facing_up: api_endpoints.dart: api endpoits
        * :page_facing_up: api_mgmt.dart: manage api call
        * :page_facing_up: model.dart: model for the session
    * :file_folder: common
        * :page_facing_up: button.dart: various buttons
        * :page_facing_up: dropdown.dart: dropdown a list of items 
        * :page_facing_up: form_fields.dart: various fields for a form
        * :page_facing_up: message.dart: various messages which can be used in alert for example
        * :page_facing_up: multi_select.dart: generate a multi select item
    * :file_folder: Data_table
        * :page_facing_up: row_source_computer.dart: generate each rows in the list of computer
        * :page_facing_up: row_source_ticket.dart: generate each rows in the list of ticket
    * :file_folder: models
        * :page_facing_up: bar_model.dart: Model to get a bar in the bar chart
        * :page_facing_up: computer_model.dart: Computer model
        * :page_facing_up: entity.dart: Entity model
        * :page_facing_up: item_ticket.dart: Item ticket model
        * :page_facing_up: itil_category.dart: Category model
        * :page_facing_up: itil_followup.dart: ITIL followup model
        * :page_facing_up: location.dart: Location model
        * :page_facing_up: special_status.dart: Special status model
        * :page_facing_up: state_computer.dart: State computer model
        * :page_facing_up: task.dart: Task model
        * :page_facing_up: ticket_user.dart: Ticket user model
        * :page_facing_up: tickets_model.dart: Ticket model
        * :page_facing_up: update_source.dart/ Update source model
        * :page_facing_up: user.dart: User model
    * :file_folder: UI
        * :page_facing_up: authentification.dart: UI authentifacation 
        * :page_facing_up: computers_page.dart: UI all computers
        * :page_facing_up: create_computer.dart: UI create a computer
        * :page_facing_up: create_ticket.dart: UI create a ticket
        * :page_facing_up: detail_computer.dart: UI show more information of computer
        * :page_facing_up: detail_ticket.dart/ UI show more information of a computer
        * :page_facing_up: home_page.dart: UI home page
        * :page_facing_up: navigation_drawer.dart: UI menu button
        * :page_facing_up: ticket_page.dart: UI all tickets
    * :page_facing_up: application.dart: set the language
    * :page_facing_up: main.dart: main 
    * :page_facing_up: translations.dart: manage transalations

* :file_folder: locale
    * :page_facing_up: i18n_en.json: English transalation
    * :page_facing_up: i18n_fr.json: French translation

