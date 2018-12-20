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
    m_update_delay = m_settings->value("update_delay", 1000*60*5).toInt();
    m_session_id = m_settings->value("session_id").toString();
    m_username = m_settings->value("username").toString();
    m_profile_url = m_settings->value("profile_url").toString();
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

QString Settings::sessionId() const
{
    return m_session_id;
}

void Settings::setSessionId(QString sessionId)
{
    if (m_session_id != sessionId){
        m_session_id = sessionId;
        m_settings->setValue("session_id", sessionId);
        emit sessionIdChanged();
    }
}

QString Settings::username() const
{
    return m_username;
}

void Settings::setUsername(QString username)
{
    if (m_username != username){
        m_username = username;
        m_settings->setValue("username", username);
        emit usernameChanged();
    }
}

QString Settings::profileUrl() const
{
    return m_profile_url;
}

void Settings::setProfileUrl(QString profileUrl)
{
    if (m_profile_url != profileUrl){
        m_profile_url = profileUrl;
        m_settings->setValue("profile_url", profileUrl);
        emit profileUrlChanged();
    }
}
