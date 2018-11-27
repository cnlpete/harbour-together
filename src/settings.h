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

class Settings : public QObject
{
    Q_OBJECT
    Q_ENUMS(SortBy)
    Q_PROPERTY(SortBy order READ order WRITE setOrder NOTIFY orderChanged)
    Q_PROPERTY(int updateDelay READ updateDelay WRITE setUpdateDelay NOTIFY updateDelayChanged)
public:
    enum SortBy {
        Date,
        Activity,
        Answers,
        Votes
    };

    Settings(QObject *parent=0);

    SortBy order() const;
    void setOrder(SortBy order);

    int updateDelay() const;
    void setUpdateDelay(int delay);

signals:
    void orderChanged();
    void updateDelayChanged();

private:
    Q_DISABLE_COPY(Settings)

    QSettings *m_settings;
    SortBy m_order;
    int m_update_delay;

    void loadSettings();
};

#endif // SETTINGS_H
