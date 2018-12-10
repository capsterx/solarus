/*
 * Copyright (C) 2006-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus Quest Editor is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus Quest Editor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/gui/quests_model.h"
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/QuestProperties.h"
#include <QApplication>
#include <algorithm>

namespace SolarusGui {

/**
 * @brief Creates a quests view.
 * @param parent Parent object or nullptr.
 */
QuestsModel::QuestsModel(QObject* parent) :
  QAbstractTableModel(parent),
  quests() {

}

/**
 * @brief Returns the number of quests.
 * @param parent Parent index.
 * @return The number of quests.
 */
int QuestsModel::rowCount(const QModelIndex& parent) const {

  Q_UNUSED(parent);
  return quests.size();
}

/**
 * @brief Returns the number of columns.
 * @param parent Parent index.
 * @return The number of columns.
 */
int QuestsModel::columnCount(const QModelIndex& parent) const {

  Q_UNUSED(parent);
  return 2;
}

/**
 * @brief Returns the header data of a column.
 * @param section Index of the section.
 * @param orientation Vertical or horizontal.
 * @param role Kind of data to get.
 * @return The header data.
 */
QVariant QuestsModel::headerData(
    int section,
    Qt::Orientation orientation,
    int role) const {

  if (role == Qt::DisplayRole) {
    switch (section) {

    case QUEST_COLUMN:
      return tr("Quest");

    case FORMAT_COLUMN:
      return tr("Format");
    }
  }

  return QAbstractTableModel::headerData(section, orientation, role);
}

/**
 * @brief Returns the data of an item for the given role.
 * @param index Index of the item to get.
 * @param role Kind of data to get.
 * @return The data for this item and this role.
 */
QVariant QuestsModel::data(const QModelIndex& index, int role) const {

  if (index.row() < 0 || index.row() >= rowCount()) {
    return QVariant();
  }

  const QuestInfo& quest_info = quests.at(index.row());

  switch (role) {

  case Qt::ItemDataRole::DisplayRole:
    switch (index.column()) {

    case QUEST_COLUMN:
      load_icon(index.row());
      return QVariant::fromValue(quest_info);

    case FORMAT_COLUMN:
      return QString::fromStdString(quest_info.properties.get_solarus_version());

    default:
      return QVariant();
    }

  case Qt::ItemDataRole::ToolTipRole:
    switch (index.column()) {

    case QUEST_COLUMN:
    return QString::fromStdString(
            quest_info.properties.get_title());

    default:
      return QVariant();
    }

  default:
    return QVariant();
  }
}

/**
 * @brief Finds the index of a quest in the list.
 * @param quest_path Path of the quest to look for.
 * @return The quest index, or -1 if it is not in the list.
 */
int QuestsModel::path_to_index(const QString& quest_path) const {

  for (size_t i = 0; i < quests.size(); ++i) {
    if (quests[i].path == quest_path) {
      return i;
    }
  }

  return -1;
}

/**
 * @brief Returns the quest path at the given index.
 * @param quest_index Index of the quest to get.
 * @return The path, or an empty string if the index is invalid.
 */
QString QuestsModel::index_to_path(int quest_index) const {

  if (quest_index < 0 || quest_index >= (int) quests.size()) {
    return QString();
  }

  return quests[quest_index].path;
}

/**
 * @brief Returns whether the model contains the given quest path.
 * @param quest_path Quest path to test.
 * @return @c true if it is in the model.
 */
bool QuestsModel::has_quest(const QString& quest_path) {

  return path_to_index(quest_path) != -1;
}

/**
 * @brief Adds a quest to the model.
 * @param quest_path Path of the quest to add.
 * @return @c true if it was added, @c false if there is no such quest
 * or if it is already there.
 */
bool QuestsModel::add_quest(const QString& quest_path) {

  if (has_quest(quest_path)) {
    return false;
  }

  QuestInfo info;

  // Open the quest to get its quest.dat file.
  QStringList arguments = QApplication::arguments();
  QString program_name = arguments.isEmpty() ? QString() : arguments.first();
  if (!Solarus::QuestFiles::open_quest(program_name.toStdString(),
                                       quest_path.toStdString())) {
    Solarus::QuestFiles::close_quest();
    return false;
  }
  info.properties = Solarus::CurrentQuest::get_properties();
  Solarus::QuestFiles::close_quest();

  const int num_quests = rowCount();
  beginInsertRows(QModelIndex(), num_quests, num_quests);

  info.path = quest_path;
  info.directory_name = quest_path.section('/', -1, -1, QString::SectionSkipEmpty);
  quests.push_back(info);

  endInsertRows();

  return true;
}

/**
 * @brief Removes a quest from this model.
 * @param quest_index Index of the quest to remove.
 * @return @c true if the quest was removed, @c false if there is no quest
 * with this index.
 */
bool QuestsModel::remove_quest(int quest_index) {

  if (quest_index < 0 || quest_index > rowCount()) {
    return false;
  }

  beginRemoveRows(QModelIndex(), quest_index, quest_index);
  quests.erase(quests.begin() + quest_index);
  endRemoveRows();
  return true;
}

/**
 * @brief Returns the list of quests paths in the model.
 * @return The quests paths.
 */
QStringList QuestsModel::get_paths() const {

  QStringList paths;
  for (const QuestInfo& info : quests) {
    paths << info.path;
  }
  return paths;
}

/**
 * @brief Returns the properties of a quest in the model.
 * @param quest_index Index of the quest to get.
 * @return The quest properties.
 */
Solarus::QuestProperties QuestsModel::get_quest_properties(int quest_index) const {

  if (quest_index < 0 || quest_index > rowCount()) {
    return Solarus::QuestProperties();
  }

  return quests[quest_index].properties;
}

/**
 * @brief Returns the default logo for a quest.
 * @return The default logo
 */
const QPixmap& QuestsModel::get_quest_default_logo() const {

  static const QPixmap default_logo(":/images/no_logo.png");

  return default_logo;
}

/**
 * @brief Returns the quest logo.
 * @param quest_index Index of the quest to get.
 * @return The quest logo.
 */
const QPixmap& QuestsModel::get_quest_logo(int quest_index) const {

  if (quest_index < 0 || quest_index > rowCount()) {
    return get_quest_default_logo();
  }

  QuestInfo& quest = quests[quest_index];
  if (quest.logo.isNull()) {
    // Lazily load the logo.
    quest.logo = get_quest_default_logo();

    QStringList arguments = QApplication::arguments();
    QString program_name = arguments.isEmpty() ? QString() : arguments.first();
    if (Solarus::QuestFiles::open_quest(program_name.toStdString(),
                                        quest.path.toStdString())) {
      std::string file_name = "logos/logo.png";
      if (Solarus::QuestFiles::data_file_exists(file_name) &&
          !Solarus::QuestFiles::data_file_is_dir(file_name)) {
        std::string buffer = Solarus::QuestFiles::data_file_read(file_name);
        QPixmap pixmap;
        if (pixmap.loadFromData((const uchar*) buffer.data(), (uint) buffer.size())) {
          quests[quest_index].logo = pixmap;
        }
      }
    }
    Solarus::QuestFiles::close_quest();
  }

  return quest.logo;
}

/**
 * @brief Returns the default icon for a quest.
 * @return The default icon.
 */
const QIcon& QuestsModel::get_quest_default_icon() const {

  static const QIcon default_icon(":/images/default_icon.png");

  return default_icon;
}

/**
 * @brief Loads the icon of the given quest.
 * @param quest_index Index of a quest.
 */
void QuestsModel::load_icon(int quest_index) const {

  if (quest_index < 0 || quest_index > rowCount()) {
    return;
  }

  QuestInfo& quest = quests[quest_index];
  QIcon& icon = quest.icon;
  if (!icon.isNull()) {
    // Already loaded.
    return;
  }

  QStringList arguments = QApplication::arguments();
  QString program_name = arguments.isEmpty() ? QString() : arguments.first();
  if (!Solarus::QuestFiles::open_quest(program_name.toStdString(),
                                       quest.path.toStdString())) {
    Solarus::QuestFiles::close_quest();
    icon = get_quest_default_icon();
    return;
  }

  QStringList file_names = {
    "logos/icon_16.png",
    "logos/icon_24.png",
    "logos/icon_32.png",
    "logos/icon_48.png",
    "logos/icon_64.png",
    "logos/icon_128.png",
    "logos/icon_256.png",
    "logos/icon_512.png",
    "logos/icon_1024.png",
  };
  for (const QString& file_name : file_names) {
    if (Solarus::QuestFiles::data_file_exists(file_name.toLocal8Bit().toStdString())) {
      std::string buffer = Solarus::QuestFiles::data_file_read(file_name.toLocal8Bit().toStdString());
      QPixmap pixmap;
      if (!pixmap.loadFromData((const uchar*) buffer.data(), (uint) buffer.size())) {
        continue;
      }
      icon.addPixmap(pixmap);
    }
  }
  Solarus::QuestFiles::close_quest();

  if (icon.isNull()) {
    icon = get_quest_default_icon();
  }
}

} // namespace SolarusGui
