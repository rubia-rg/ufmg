long int ebase=0,velbase=0,velabsbase=0;
long int refbase=0; 
long int posbase;
long int fposbase;

long int elanca=0,vellanca=0,velabslanca=0;
long int reflanca=0; 
long int poslanca;
long int fposlanca;

int chave;

int n=10;
int delta=2;
int movbase;
int movlanca;




void contadorbase(){
  if (velbase>0){
 fposbase++; 
 posbase=fposbase/4;
 }
  if(velbase<0){
 fposbase--; 
 posbase=fposbase/4;    
  }
  
 }

 

void contadorlanca(){
  if (vellanca>0){
 fposlanca++; 
 poslanca=fposlanca/4;
 }
  if(vellanca<0){
 fposlanca--; 
 poslanca=fposlanca/4;    
  }
  
 }
 
 


void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  attachInterrupt(0, contadorbase, RISING  );
  attachInterrupt(1, contadorlanca, RISING  );

}


void loop(){
 
  

   //Comando
chave=digitalRead(4);
if (chave==0){  
  movbase=Serial.read();
}else{
  movlanca=Serial.read();
}

 if (movbase==49){ 
    refbase=refbase+delta;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.print("Interval: ");
   
  }
  if (movbase==50){
    refbase=refbase-delta;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.print("Interval: ");
   
  }
  
    if (movbase==51){
    refbase=posbase;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.print("Interval: ");
   
  }

//Erro  
  ebase=int(refbase-posbase);
    
  velbase=int((refbase-posbase))*15 ;


if (velbase<0){
      if (velbase>-50){
        velbase=-50;
    }

     if (ebase>2){   
      velbase=0;
      }

    if (velbase<150){
      velbase=-150;
    }


}

    if (velbase>0){
      if (velbase<50){
        velbase=50;
    }

     if (ebase<2){   
      velbase=0;
      }

    if (velbase>150){
      velbase=150;
    }
}

velabsbase=velbase;
abs(velabsbase);

if (velbase>0){
  analogWrite(9, velabsbase);
  analogWrite(10, 0);
  
}else{
  analogWrite(10, velabsbase);
  analogWrite(9, 0);
}



  

   //Comando
 
 



  if (movlanca==49){ 
    reflanca=reflanca+delta;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.print("Interval: ");    
    Serial.println(chave);
   
  }
  if (movlanca==50){
    reflanca=reflanca-delta;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.print("Interval: ");
   
  }
  
    if (movlanca==51){
    reflanca=poslanca;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.print("Interval: ");
   
  }

//Erro  
  elanca=int(reflanca-poslanca);
    
  vellanca=int((reflanca-poslanca))*15 ;


if (vellanca<0){
      if (vellanca>-50){
        vellanca=-50;
    }

     if (elanca>2){   
      vellanca=0;
      }

    if (vellanca<150){
      vellanca=-150;
    }


}

    if (vellanca>0){
      if (vellanca<50){
        vellanca=50;
    }

     if (elanca<2){   
      vellanca=0;
      }

    if (vellanca>150){
      vellanca=150;
    }
}

velabslanca=vellanca;
abs(velabslanca);

if (vellanca>0){
  analogWrite(6, velabslanca);
  analogWrite(11, 0);
  
}else{
  analogWrite(11, velabslanca);
  analogWrite(6, 0);
}
}