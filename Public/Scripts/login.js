    function loginTabClicked() {	
      document.querySelector('.auth-tabs__login').style.cssText = 'border-width: 1px 1px 0px 1px; border-color: gray; border-style: solid; background-color: white; color: black;';
      document.querySelector('.auth-tabs__signup').style.cssText = 'border-width: 1px 1px 1px 0px; border-color: gray; border-style: solid; color: rgb(151, 159, 175);';
      
      document.getElementById('login-tab').classList.remove('auth-form_hidden')
      document.getElementById('signup-tab').classList.add('auth-form_hidden')
    }

    function signupTabClicked() {
      document.querySelector('.auth-tabs__login').style.cssText = 'border-width: 1px 1px 1px 1px; border-color: gray; border-style: solid; color: rgb(151, 159, 175);';
      document.querySelector('.auth-tabs__signup').style.cssText = 'border-width: 1px 1px 0px 0px; border-color: gray; border-style: solid; background-color: white; color: black;';
    
      document.getElementById('login-tab').classList.add('auth-form_hidden')
      document.getElementById('signup-tab').classList.remove('auth-form_hidden')
    }
