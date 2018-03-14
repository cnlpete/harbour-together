#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
    Q_ENUMS(SortBy)
    Q_PROPERTY(SortBy order READ order WRITE setOrder NOTIFY orderChanged)
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

signals:
    void orderChanged();

private:
    Q_DISABLE_COPY(Settings)

    QSettings *m_settings;
    SortBy m_order;

    void loadSettings();
};

#endif // SETTINGS_H
