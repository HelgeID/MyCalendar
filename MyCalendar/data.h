#ifndef DATA_H
#define DATA_H

#include <QObject>
#include <string>
using namespace std;

class Data: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dateDay READ getDateDay WRITE setDateDay NOTIFY sigDay)
    Q_PROPERTY(int dateMonth READ getDateMonth WRITE setDateMonth NOTIFY sigMonth)
    Q_PROPERTY(int dateYear READ getDateYear WRITE setDateYear NOTIFY sigYear)

private:
    int dateDay;
    int dateMonth;
    int dateYear;

    int counter;
    void ToFile(const string);
    void ToFileOverwrite(const string);
    string FromFile();

    string CreateNote(const string);
    string DeleteNote(const int);
    string ReadNote(const int);

    void operator+ (string);
    void operator- (const int);
    string operator[] (const int);

    void setDateDay(const int&);
    void setDateMonth(const int&);
    void setDateYear(const int&);
    int getDateDay();
    int getDateMonth();
    int getDateYear();

public:
    explicit Data(QObject *parent = nullptr);
    Q_INVOKABLE void addNote(QString);
    Q_INVOKABLE void delNote(const int);
    Q_INVOKABLE QString getNote(const int);

    Q_INVOKABLE QString getNoteDateDay(const int);
    Q_INVOKABLE QString getNoteDateMonthYear(const int);

    Q_INVOKABLE int takeCounter();

signals:
    void sigDay();
    void sigMonth();
    void sigYear();
};

#endif // DATA_H
