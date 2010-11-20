$(document).ready( function() {

	/**
	 * Customize this function as you wish!
     * Add your validation below the email if.
     *
     * Change the behaviour of the plugin by editing this line:
     * 		$(this).blur( function() { validateField(this) } );
     * To:
     *      $(this).keyup( function() { validateField(this) } );
     *
     *  You can find it around the line number 64.
	 */
	function validateField(field) {
		var error = false;
		
		// required fields
		if ($(field).attr("class").indexOf("required") != -1) {
			if (!$(field).val().length)
				error = true;
		}
		// numeric fields
		if ($(field).attr("class").indexOf("numeric") != -1) {
			if (!/^[0-9]*$/.test($(field).val()))
				error = true;
		}
		// characters (letters)
		if ($(field).attr("class").indexOf("character") != -1) {
			if (!/^[a-zA-ZöÖäÄåÅ]*$/.test($(field).val()))
				error = true;
		}
		// emails
		if ($(field).attr("class").indexOf("email") != -1) {
			if (!/^[a-zA-Z0-9]{1}([\._a-zA-Z0-9-]+)(\.[_a-zA-Z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+){1,3}$/.test($(field).val()))
				error = true;
		}
		// date fields
		if ($(field).attr("class").indexOf("date") != -1) {
			if (!/(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d/.test($(field).val()))
        			error = true;
		}
		
		if (error) {
			$(field).addClass("error");
		} else {
			$(field).removeClass("error");
		}
		
		return !error;
	}
	
	$("form").each( function() {
		// handle submissions without filling any field
		$(this).submit(function () {
			var validationError = false;
			// for each field test it
			$("input, select, textarea", this).each( function() {
				if ($(this).attr("class")) {
					if (!validateField(this))
						validationError = true;
				}
			});
			return !validationError;
		});
	
		// handle changes on the fly
		$("input, select, textarea", this).each( function() {
			if ($(this).attr("class")) {
				$(this).blur( function() { validateField(this) } );
    			}
		});
	});
});

function init_validate() {
      /**
	 * Customize this function as you wish!
     * Add your validation below the email if.
     *
     * Change the behaviour of the plugin by editing this line:
     * 		$(this).blur( function() { validateField(this) } );
     * To:
     *      $(this).keyup( function() { validateField(this) } );
     *
     *  You can find it around the line number 64.
	 */
	
	$("form").each( function() {
		// handle submissions without filling any field
		$(this).submit(function () {
			var validationError = false;
			// for each field test it
			$("input, select, textarea", this).each( function() {
				if ($(this).attr("class")) {
					if (!validateField(this))
						validationError = true;
				}
			});
			return !validationError;
		});
	
		// handle changes on the fly
		$("input, select, textarea", this).each( function() {
			if ($(this).attr("class")) {
				$(this).blur( function() { validateField(this) } );
    			}
		});
	});
}

function validateField(field) {
        var error = false;

        // required fields
        if ($(field).attr("class").indexOf("required") != -1) {
            if (!$(field).val().length)
                error = true;
	}
	// numeric fields
	if ($(field).attr("class").indexOf("numeric") != -1) {
            if (!/^[0-9]*$/.test($(field).val()))
                error = true;
        }
        // characters (letters)
        if ($(field).attr("class").indexOf("character") != -1) {
            if (!/^[a-zA-ZöÖäÄåÅ]*$/.test($(field).val()))
                error = true;
        }
	// emails
	if ($(field).attr("class").indexOf("email") != -1) {
            if (!/^[a-zA-Z0-9]{1}([\._a-zA-Z0-9-]+)(\.[_a-zA-Z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+){1,3}$/.test($(field).val()))
                error = true;
        }
        // date fields
        if ($(field).attr("class").indexOf("date") != -1) {
            if (!/(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d/.test($(field).val()))
                error = true;
        }
	if (error) {
            $(field).addClass("error");
        } else {
            $(field).removeClass("error");
	}
	return !error;
}