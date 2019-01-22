#ifndef CRANECONTOLLER_H
#define CRANECONTOLLER_H

#include <QObject>

class CraneController : public QObject
{
    Q_OBJECT

public:
    CraneController(int _angleValue = 0, int _heightValue = 0, QObject *parent = nullptr) :
        QObject(parent)
    {

        _angle = _angleValue;
        _height = _heightValue;
    }

    int angleVal() const;
    int heightVal() const;

    int tempAngleVal() const;
    int tempHeightVal() const;

public slots:
    void sendAngle();
    void setTempAngle(int);

    void sendHeight();
    void setTempHeight(int);

signals:
    void valueAngleChanged(int);
    void valueHeightChanged(int);

    void tempAngleValChanged(int);
    void tempHeightValChanged(int);

private:
    int _angle;
    int _height;

    int tempAngle;
    int tempHeight;
};

#endif // CRANECONTOLLER_H
