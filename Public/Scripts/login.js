
    function loginTabClicked() {	
      document.querySelector('.auth-tabs__login').style.cssText = 'border-width: 1px 1px 0px 1px; border-color: gray; border-style: solid; background-color: white; color: black;';
      document.querySelector('.auth-tabs__signup').style.cssText = 'border-width: 1px 1px 1px 0px; border-color: gray; border-style: solid; color: rgb(151, 159, 175);';
      
      document.getElementById('login-tab').classList.add('auth-form_selected')
      document.getElementById('signup-tab').classList.remove('auth-form_selected')
    }

    function signupTabClicked() {
      document.querySelector('.auth-tabs__login').style.cssText = 'border-width: 1px 1px 1px 1px; border-color: gray; border-style: solid; color: rgb(151, 159, 175);';
      document.querySelector('.auth-tabs__signup').style.cssText = 'border-width: 1px 1px 0px 0px; border-color: gray; border-style: solid; background-color: white; color: black;';
    
      document.getElementById('login-tab').classList.remove('auth-form_selected')
      document.getElementById('signup-tab').classList.add('auth-form_selected')
    }

    function submitLogin() {
      var form = document.querySelector('.auth-form_selected')
      var username = form.querySelector('.auth-form__username-input').value
      var password = form.querySelector('.auth-form__password-input').value
      loginUser(username, password)
    }

    function submitSignup() {
      var form = document.querySelector('.auth-form_selected')
      var username = form.querySelector('.auth-form__username-input').value
      var email = form.querySelector('.auth-form__email-input').value
      var password = form.querySelector('.auth-form__password-input').value

      axios.post('/api/users', {
      	username,
      	email,
      	password
      }).then((response)=>{
      	loginUser(username, password)
      })
    }

    function loginUser(username, password) {
	    axios.post('/api/login', {}, {
	      	headers: {
	      		Authorization: 'Basic '+ btoa(username + ':' + password)
	      	}
	      }).then((response)=>{
	      	localStorage.setItem('token', response.data.token);
	      	axios.get('/posts', {
	      		headers: {
	      			Authorization: 'Bearer '+ response.data.token
	      		}
	      	}).then((response)=>{
	      		document.write(response.data)
	      	})
	      })
    }
