#include <fstream>
#include <iostream>
#include <sstream>
#include <algorithm>

#include "data.h"

#define DATA_NAME "Data"
#define CH_END_LINE   '\n'
#define CH_IN         '['
#define CH_OUT        ']'
#define CH_SPACE      ' '
#define CH_POINT      '.'

#define ERROR_OPENING "Error opening file: Data, Please create a file!"


Data::Data(QObject *parent): QObject(parent), counter(0)
{
    //reading counter from a file
    ifstream dataFile(DATA_NAME);
    if (dataFile.is_open()) {
        string line;
        int i(0); string s_ind("");
        while (getline(dataFile, line)) {
            try {
                if (!line.empty())
                    throw nullptr;
            }

            catch (...)
            {
                if (line.at(0) == CH_IN) {
                repeat:
                    if (line.at(++i) != CH_OUT) {
                        s_ind = s_ind + line.at(i);
                        goto repeat;
                    }
                    else
                        if (!s_ind.empty()) {
                            s_ind = ""; i = 0;
                            counter = counter + 1;
                        }
                }
            }
        }
        dataFile.close();
    }
}

int Data::takeCounter() { return counter; }

void Data::addNote(QString text)
{
    Data& obj(*this);
    obj + text.toStdString();
    return;
}

void Data::delNote(const int index)
{
    Data& obj(*this);
    obj - index;
    return;
}

QString Data::getNote(const int index)
{
    Data& obj(*this);
    string text(obj[index]);
    return QString::fromStdString(text);
}

// AddNote, DelNote, GetNote
void Data::operator+(string text) { counter += 1; ToFile(CreateNote(text)); }
void Data::operator-(const int index) { counter -= 1; ToFileOverwrite(DeleteNote(index)); }
string Data::operator[](const int index) { return ReadNote(index); }

void Data::ToFile(const string text)
{
    fstream dataFile;
    dataFile.open(DATA_NAME, ios::in | ios::out | ios::app);
    for (size_t i(0); i < text.size(); i++)
        dataFile.put(text[i]);
    dataFile.close();
    return;
}

void Data::ToFileOverwrite(const string text)
{
    ofstream dataFile(DATA_NAME);
    for (size_t i(0); i < text.size(); i++)
        dataFile.put(text[i]);
    dataFile.close();
    return;
}

string Data::CreateNote(const string text)
{
    string note = "";
    ostringstream oss;

    note += CH_IN;
        (counter >= 1 && counter <= 9) ? note += "0" + to_string(counter) : note += to_string(counter);
    note += CH_OUT;
    note += CH_SPACE;
    note += CH_IN;
        string data = "", buff = "";

        oss << getDateDay(); buff = oss.str();
        buff.length() > 1 ? buff : buff = '0' + buff; data += buff; oss.str("");
        data += CH_POINT;
        oss << getDateMonth(); buff = oss.str();
        buff.length() > 1 ? buff : buff = '0' + buff; data += buff; oss.str("");
        data += CH_POINT;
        oss << getDateYear(); buff = oss.str();
        buff.length() > 1 ? buff : buff = '0' + buff; data += buff; oss.str("");
        note += data;

    note += CH_OUT;
    note += CH_END_LINE;
    note += text;
    note += CH_END_LINE;
    note += CH_END_LINE;
    return note;
}

string Data::FromFile()
{
    ifstream dataFile(DATA_NAME);
    if (dataFile.is_open())
    {
        char symbol;
        string text = "";
        while (!dataFile.eof()) {
            dataFile.get(symbol);
            text = text + symbol;
        }
        text.pop_back();
        dataFile.close();
        return text;
    }
    else {
        return ERROR_OPENING;
    }
}

string TakeDate(const string& iStr, bool qmlformat = false)
{
    //iStr - index on line, dStr - date on line
    ifstream dataFile(DATA_NAME);
    string line, dStr("");

    size_t length = iStr.length();
    while (getline(dataFile, line)) {
        try
        {
            if (!line.empty())
                throw nullptr;
        }

        catch (...)
        {
            if (line.at(0) == iStr.at(0)) {
                size_t counter(0);
                for (size_t i(0); i < length; i++)
                    if (line.at(i) == iStr.at(i))
                        counter = counter + 1;
                if (counter == length) {
                    size_t length = line.length() - counter;
                    for (size_t i(1); i < length - 1; i++)
                        dStr += line.at(counter + i);
                    break;
                }
            }
        }
    }

    if (qmlformat) {
        string arr[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" };
        string sIn("."), sOut("/");
        size_t pos;
        while ((pos = dStr.find(sIn)) != dStr.npos)
            dStr.replace(pos, 1, sOut);

        string s_month("");
        char ch;
        ch = dStr.at(3); s_month = s_month + ch;
        ch = dStr.at(4); s_month = s_month + ch;
        int month(stoi(s_month));

        const int posNum(3);
        for (size_t index = 12; index != 0; index--) {
            if (month == index) {
                dStr.erase(posNum, 1);
                dStr.erase(posNum, 1);
                dStr.insert(posNum, arr[index-1]);
            }
        }
    }

    dataFile.close();
    return dStr;
}

string Data::ReadNote(const int index)
{
    ifstream dataFile(DATA_NAME);
    string text = "";
    if (dataFile.is_open())
    {
        string line, str(""), next("");
        str += CH_IN; next += CH_IN;
        (index >= 1 && index <= 9) ? str += "0" + to_string(index) : str += to_string(index);
        (index + 1 >= 1 && index + 1 <= 9) ? next += "0" + to_string(index + 1) : next += to_string(index + 1);
        str += CH_OUT; next += CH_OUT;
        str += CH_SPACE; next += CH_SPACE;

        string str_buff(str);
        str += CH_IN;
        str += TakeDate(str_buff);//format arg: "[00] "
        str += CH_OUT;

        bool rFlag(false);
        const char *c_next = const_cast<char*>(next.c_str());
        const char *c_line;
        while (getline(dataFile, line)) {
            c_line = const_cast<char*>(line.c_str());
            if (rFlag && strncmp(c_line, c_next, next.length())) {
                text.append(line);
                text += CH_END_LINE;
            }
            else
                rFlag = false;

            if (line == str)
                rFlag = true;
        }
    }
    else {
        return ERROR_OPENING;
    }
    dataFile.close();
    return text;
}

QString Data::getNoteDateDay(const int index)
{
    //uses fun TakeDate()

    string str = "";
    (index >= 1 && index <= 9) ? str += "0" + to_string(index) : str += to_string(index);
    str = CH_IN + str + CH_OUT + CH_SPACE;
    str = TakeDate(str, true);

    //get day
    int i(0); string day("");
    while(true) {
        if (str.at(i++) != '/')
            day += str.at(i-1);
        else break;
    }
    return QString::fromStdString(day);
}

QString Data::getNoteDateMonthYear(const int index)
{
    //uses fun TakeDate()

    string str = "";
    (index >= 1 && index <= 9) ? str += "0" + to_string(index) : str += to_string(index);
    str = CH_IN + str + CH_OUT + CH_SPACE;
    str = TakeDate(str, true);

    //get month/year
    const int pos1(3);
    const int pos2(10);
    string month_year("");
    month_year = str.substr(pos1, pos2 - pos1 + 1);
    return QString::fromStdString(month_year);
}

void OverWriteIndex(string& line, const string str)
{
    for (size_t i(0); i < str.length(); i++)
        line.erase(line.begin());
    stringstream ss;
    ss << str << line;
    line = ss.str().c_str();
    return;
}

string Data::DeleteNote(const int index)
{
    ifstream dataFile(DATA_NAME);
    string text = "";
    if (dataFile.is_open())
    {
        int indNum(NULL), iIndex(NULL);
        for (int i=1, coeff=10; i<=6; ++i, coeff*=10)
            if (counter % coeff == counter) {
                indNum = i; break;
            }

        if (indNum == NULL)
            return ERROR_OPENING;

        string ind(""), next("");
        (index >= 1 && index <= 9) ? ind += "0" + to_string(index) : ind += to_string(index);
        (index + 1 >= 1 && index + 1 <= 9) ? next += "0" + to_string(index + 1) : next += to_string(index + 1);

        ind = CH_IN + ind + CH_OUT;
        next = CH_IN + next + CH_OUT;
        const char *c_ind = const_cast<char*>(ind.c_str());
        const char *c_next = const_cast<char*>(next.c_str());

        bool dFlag(false);
        string line;
        const char *c_line;
        while (getline(dataFile, line)) {
            c_line = const_cast<char*>(line.c_str());
            if (!strncmp(c_line, c_ind, ind.length()) && !dFlag) {
                dFlag = true;
            }
            else {
                if (!dFlag) {
                    if (line[0] == CH_IN && line[indNum+2] == CH_OUT && line[indNum+3] == CH_SPACE) {
                        string sIndex = to_string(++iIndex);
                        (iIndex >= 1 && iIndex <= 9) ? sIndex = '0' + sIndex : sIndex;
                        string str = CH_IN + sIndex + CH_OUT;
                        OverWriteIndex(line, str);
                    }

                    text += line;
                    text += CH_END_LINE;
                }
            }
            if (!strncmp(c_line, c_next, next.length()) && dFlag) {
                if (line[0] == CH_IN && line[indNum+2] == CH_OUT && line[indNum+3] == CH_SPACE) {
                    string sIndex = to_string(++iIndex);
                    (iIndex >= 1 && iIndex <= 9) ? sIndex = '0' + sIndex : sIndex;
                    string str = CH_IN + sIndex + CH_OUT;
                    OverWriteIndex(line, str);
                }

                text += line;
                text += CH_END_LINE;
                dFlag = false;
            }
        }
    }
    else {
        return ERROR_OPENING;
    }
    dataFile.close();
    return text;
}

void Data::setDateDay(const int &dateDay) {
    this->dateDay = dateDay;
    emit sigDay();
}

void Data::setDateMonth(const int &dateMonth) {
    this->dateMonth = dateMonth;
    emit sigMonth();
}

void Data::setDateYear(const int &dateYear) {
    this->dateYear = dateYear;
    emit sigYear();
}

int Data::getDateDay() {
    return dateDay;
}

int Data::getDateMonth() {
    return dateMonth;
}

int Data::getDateYear() {
    return dateYear;
}
