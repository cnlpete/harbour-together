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
    m_updateDelay = m_settings->value("update_delay", 1000*60*5).toInt();
    m_fontSize = m_settings->value("font_size", 2).toInt();
}

int Settings::updateDelay() const
{
    return m_updateDelay;
}

void Settings::setUpdateDelay(int delay)
{
    if (m_updateDelay != delay){
        m_updateDelay = delay;
        m_settings->setValue("update_delay", delay);
        emit updateDelayChanged();
    }
}

int Settings::fontSize() const
{
    return m_fontSize;
}

void Settings::setFontSize(int fontSize)
{
    if (m_fontSize != fontSize){
        m_fontSize = fontSize;
        m_settings->setValue("font_size", fontSize);
        emit fontSizeChanged();
    }
}
