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
int rc;

bool update_base = false;
bool update_lanca = false;


void contadorbase() {
  if (velbase > 0) {
    fposbase++;
    posbase = fposbase / 4;
  }
  if (velbase < 0) {
    fposbase--;
    posbase = fposbase / 4;
  }
}

void contadorlanca() {
  if (vellanca > 0) {
    fposlanca++;
    poslanca = fposlanca / 4;
  }
  if (vellanca < 0) {
    fposlanca--;
    poslanca = fposlanca / 4;
  }
}


void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  attachInterrupt(0, contadorbase, RISING  );
  attachInterrupt(1, contadorlanca, RISING  );

}

void loop() {
  
  
  rc = Serial.read();    
//
//  if(rc > 47 && rc < 53){
//    update_base = true;  
//  }
//
//  if(rc > 52 && rc < 58){
//    update_lanca = true;  
//  }

  if (rc==48){
    refbase=posbase-2;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.println();
   
  }

  if (rc==49){ 
    refbase=refbase-1;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.println(); 
  }
  
  if (rc==50){
    refbase=refbase;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);  
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.println();
   
  }

    if (rc==51){
    refbase=refbase+1;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.println();
    }

    if (rc==52){
    refbase=refbase+2;
    Serial.print("Ref: ");
    Serial.println(refbase);
    Serial.print("Velocidade: ");
    Serial.println(velbase);
    Serial.print("Posicao: ");
    Serial.println(posbase);
    Serial.println();
    }

    if (rc==53){
    reflanca=reflanca-40;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.println();
    }

    if (rc==54){
    reflanca=reflanca-20;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.println();
    }

    if (rc==55){
    reflanca=reflanca;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.println();
    }

    if (rc==56){
    reflanca=reflanca+20;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.println();
    }

    if (rc==57){
    reflanca=reflanca+40;
    Serial.print("Ref: ");
    Serial.println(reflanca);
    Serial.print("Velocidade: ");
    Serial.println(vellanca);
    Serial.print("Posicao: ");
    Serial.println(poslanca);
    Serial.println();
    }

//if(update_base){
  
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

//}
update_base = false;

//if(update_lanca){
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
//}
//update_lanca = false;

rc = 0;
}
