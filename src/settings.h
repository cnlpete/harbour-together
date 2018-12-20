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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QString>

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int updateDelay READ updateDelay WRITE setUpdateDelay NOTIFY updateDelayChanged)
    Q_PROPERTY(QString sessionId READ sessionId WRITE setSessionId NOTIFY sessionIdChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString profileUrl READ profileUrl WRITE setProfileUrl NOTIFY profileUrlChanged)
public:
    Settings(QObject *parent=0);

    int updateDelay() const;
    void setUpdateDelay(int delay);

    QString sessionId() const;
    void setSessionId(QString sessionId);

    QString username() const;
    void setUsername(QString username);

    QString profileUrl() const;
    void setProfileUrl(QString profileUrl);

signals:
    void updateDelayChanged();
    void sessionIdChanged();
    void usernameChanged();
    void profileUrlChanged();

private:
    Q_DISABLE_COPY(Settings)

    QSettings *m_settings;
    int m_update_delay;
    QString m_session_id;
    QString m_username;
    QString m_profile_url;

    void loadSettings();
};

#endif // SETTINGS_H
