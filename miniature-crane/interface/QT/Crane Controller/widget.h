#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <cranecontroller.h>

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT
    
public:
    explicit Widget(QWidget *parent = nullptr);
    void WriteToArduino(QSerialPort *port, QByteArray &order);
    QByteArray ReadArduino(QSerialPort *port);
    ~Widget();
    
public slots:
    void sendAngVal(int);
    void sendHeiVal(int);

private:
    Ui::Widget *ui;
    CraneController craneControl;
    QSerialPort serialPort;
};

#endif // WIDGET_H
