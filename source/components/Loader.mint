component Loader {
  property display = false

  style spinner {
    width: 40px;
    height: 40px;
    background-color: #fff;

    margin: 100px auto;
    
   

    
  }

  style animation {
     animation: sk-rotateplane 1.2s infinite ease-in-out;
      @keyframes sk-rotateplane {
  0% {
       transform: perspective(120px);
        }
  50% { 
      transform: perspective(120px) rotateY(180deg) ;
      }
  100% { 
      transform: perspective(120px) rotateY(180deg)  rotateX(180deg);
       }
}

@keyframes sk-rotateplane {
  0% { 
    transform: perspective(120px) rotateX(0deg) rotateY(0deg);
  
  } 50% { 
    transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg);
   
  } 100% { 
    transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);

  }
}
  }

  fun render {
    if(display){
    <div::spinner::animation/>

    }else{
      Html.empty()
    }
  }
}
