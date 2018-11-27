/**
 * Copyright (C) 2018 Nguyen Long.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
