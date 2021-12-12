$(document ).ready(function() {
  classValidation()
  deityValidation()
  raceValidation()
  $('#character_characterclass_id').change(function() {
    classValidation()
    deityValidation()
  });

  $('#character_deity_id').change(function() {
    deityValidation()
  });

  $('#character_race_id').change(function() {
    raceValidation()
  });
});
  
function classValidation() {
  var firstdeityoption = $('#character_deity_id').find("option:first-child").text()
  var characterclass = $('#character_characterclass_id option:selected').text()
  var classTokenFileName = '/images/classtoken/' + characterclass.toLowerCase() + '.png'
  if (characterclass != 'Class') {
    $.ajax({
      url: '/characterclass/' + document.getElementById('character_characterclass_id').value + '/getcharacterclass',
      type: 'GET',
      dataType: 'json',
      success: function(data){
        $('#ClassDesc').html(data.shortdescription)
      }
    })
    document.getElementById('classtoken').src = classTokenFileName
    document.getElementById('classtoken').style.visibility = 'visible';
    document.getElementById('classtoken').title = characterclass;
  } else {
    document.getElementById('classtoken').style.visibility = 'hidden';
    document.getElementById('classtoken').title = '';
    $('#ClassDesc').html('')
  }

  if (characterclass == 'Druid') {
    $('#totemselect').show()
  }  else {
    document.getElementById('character_totem').selectedIndex = 0
    $('#totemselect').hide()
  }

  if (characterclass == 'Cleric' || characterclass == 'Paladin') {
    $("#character_deity_id").prop('required',true);
    if (firstdeityoption == 'Deity') {
      $('#character_deity_id').find("option:first-child").remove();
    }
  }  else {
    $("#character_deity_id").prop('required',false);
    if (firstdeityoption != 'Deity') {
      $("#character_deity_id").prepend("<option value='' selected='Deity'>Deity</option>");
    }
    
  }
  
}

function deityValidation() {
  var deity = $('#character_deity_id option:selected').text()
  var deityTokenFileName = '/images/deitytoken/' + deity.toLowerCase() + '.gif'
  if (deity != 'Deity') {
    $.ajax({
      url: '/deity/' + document.getElementById('character_deity_id').value + '/getdeity',
      type: 'GET',
      dataType: 'json',
      success: function(data){
        $('#DeityDesc').html(data.shortdescription)
      }
    })
    document.getElementById('deitytoken').src = deityTokenFileName
    document.getElementById('deitytoken').style.visibility = 'visible';
    document.getElementById('deitytoken').title = deity;
  } else {
    document.getElementById('deitytoken').style.visibility = 'hidden';
    document.getElementById('deitytoken').title = '';
    $('#DeityDesc').html('')
  }
  
}

function raceValidation() {
  var race = $('#character_race_id option:selected').text()

  if (document.getElementById("character_race_id").selectedIndex > 0) {
    $.ajax({
      url: '/race/' + document.getElementById('character_race_id').value + '/getrace',
      type: 'GET',
      dataType: 'json',
      success: function(data){
        $('#RaceDesc').html(data.shortdescription)
      }
    })
  } else {
    $('#RaceDesc').html('')
  }
  
}