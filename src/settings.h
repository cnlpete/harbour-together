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
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(bool showAvatarCover READ showAvatarCover WRITE setShowAvatarCover NOTIFY showAvatarCoverChanged)
public:
    Settings(QObject *parent=0);

    int updateDelay() const;
    void setUpdateDelay(int delay);

    int fontSize() const;
    void setFontSize(int fontSize);

    bool showAvatarCover() const;
    void setShowAvatarCover(bool flag);

signals:
    void updateDelayChanged();
    void fontSizeChanged();
    void showAvatarCoverChanged();

private:
    Q_DISABLE_COPY(Settings)

    QSettings *m_settings;
    int m_updateDelay;
    int m_fontSize;
    bool m_showAvatarCover;

    void loadSettings();
};

#endif // SETTINGS_H
