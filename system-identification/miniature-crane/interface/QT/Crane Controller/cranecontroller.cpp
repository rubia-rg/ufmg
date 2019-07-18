#include "cranecontroller.h"
#include <iostream>

using namespace std;

/* Este método irá enviar o valor de tempAngle
* para a variável _angle, que será enviada para
* o Arduino após ser decodificada de acordo com o
* protocolo
*/
void CraneController::sendAngle() {
    _angle = tempAngle;
    cout << _angle;
    emit valueAngleChanged(angleVal());
}

void CraneController::sendHeight() {
    _height = tempHeight;
    cout << _height;
    emit valueHeightChanged(heightVal());

}

void CraneController::setTempAngle(int angle)
{
    tempAngle = angle;
    emit tempAngleValChanged(tempAngleVal());

}

void CraneController::setTempHeight(int height)
{
    tempHeight = height;
    emit tempHeightValChanged(tempHeightVal());
}

int CraneController::angleVal() const
{
    return _angle;
}

int CraneController::heightVal() const
{
    return _height;
}

int CraneController::tempAngleVal() const {
    return tempAngle;
}

int CraneController::tempHeightVal() const {
    return tempHeight;
}
