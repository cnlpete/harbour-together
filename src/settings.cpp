#include "settings.h"

Settings::Settings(QObject *parent) :
    QObject(parent), m_settings(new QSettings(this))
{
    loadSettings();
}

void Settings::loadSettings()
{
    m_order = static_cast<SortBy>(m_settings->value("order", SortBy::Activity).toInt());
}

Settings::SortBy Settings::order() const
{
    return m_order;
}

void Settings::setOrder(SortBy order)
{
    if (m_order != order){
        m_order = order;
        m_settings->setValue("order", static_cast<int>(m_order));
        emit orderChanged();
    }
}
