#include "widget.h"
#include "ui_widget.h"
#include <QSlider>
#include <iostream>
#include <QtCore/QDebug>

QTextStream cinput(stdin);
QTextStream coutput(stdout);

using namespace std;

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    QString portName = "/dev/cu.usbmodem14201";
    this->serialPort.setBaudRate(QSerialPort::Baud9600);
    this->serialPort.setPortName(portName);
    this->serialPort.setDataBits(QSerialPort::Data8);
    this->serialPort.setParity(QSerialPort::NoParity);

    if(this->serialPort.open(QIODevice::ReadWrite)) {
//        serialPort.clear();
    } else {
        coutput << QObject::tr("FALHA AO ABRIR PORTA: %1").arg(this->serialPort.errorString()) << endl;
    }

    ui->setupUi(this);
    ui->heightSlider->setMinimum(-2);
    ui->heightSlider->setMaximum(2);

    ui->angleDial->setMinimum(-2);
    ui->angleDial->setMaximum(2);

    connect(ui->angleDial, SIGNAL(valueChanged(int)), ui->angleLcd, SLOT(display(int)));
    connect(ui->angleDial, SIGNAL(valueChanged(int)), &craneControl, SLOT(setTempAngle(int)));

    connect(ui->heightSlider, SIGNAL(valueChanged(int)), ui->heightLcd, SLOT(display(int)));
    connect(ui->heightSlider, SIGNAL(valueChanged(int)), &craneControl, SLOT(setTempHeight(int)));

    connect(ui->okAngle, SIGNAL(clicked()), &craneControl, SLOT(sendAngle()));
    connect(ui->okHeight, SIGNAL(clicked()), &craneControl, SLOT(sendHeight()));

    connect(&craneControl, SIGNAL(valueAngleChanged(int)), this, SLOT(sendAngVal(int)));
    connect(&craneControl, SIGNAL(valueHeightChanged(int)), this, SLOT(sendHeiVal(int)));


}

void Widget::sendAngVal(int val) {
    // escrever na porta serial por aqui
   QByteArray angleBA;

   angleBA.setNum(val+2);
   WriteToArduino(&serialPort, angleBA);
//   coutput << angleBA << endl;
   angleBA.clear();
}

void Widget::sendHeiVal(int val) {
    QByteArray heightBA;

    heightBA.setNum(val+7);
    WriteToArduino(&serialPort, heightBA);
//    coutput << heightBA << endl;
    heightBA.clear();
}

void Widget::WriteToArduino(QSerialPort *port, QByteArray &order) {
    qint64 bytesWritten = port->write(order);
}

QByteArray Widget::ReadArduino(QSerialPort *port)
{
    QByteArray readData;
    /* Vou aguardar X ms, no caso 75, para ver os dados disponiveis e começar a leitura
        (-1) não possuira timeout.
    */
    while (port->waitForReadyRead(75)) {
        readData.append(port->readAll());
    }

    /* Descomentar a linha abaixo apenas para debug da recepçao serial */
//    coutput << readData <<  endl;
    return readData;
}


Widget::~Widget()
{
    this->serialPort.close();
    delete ui;
}
