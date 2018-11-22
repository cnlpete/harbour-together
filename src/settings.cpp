#include "settings.h"

Settings::Settings(QObject *parent) :
    QObject(parent), m_settings(new QSettings(this))
{
    loadSettings();
}

void Settings::loadSettings()
{
    m_order = static_cast<SortBy>(m_settings->value("order", SortBy::Activity).toInt());
    m_update_delay = m_settings->value("update_delay", 1000*60*5).toInt();
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

int Settings::updateDelay() const
{
    return m_update_delay;
}

void Settings::setUpdateDelay(int delay)
{
    if (m_update_delay != delay){
        m_update_delay = delay;
        m_settings->setValue("update_delay", delay);
        emit updateDelayChanged();
    }
}
