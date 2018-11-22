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
