function toBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = reject;
    });
}

function submitText(){
    submitted = document.getElementById('submittedText').value
    $.ajax({
        url : '/ipfs',
        type : 'POST',
        data : { 'text' : submitted },
        success : function(responsedata) {              
            console.log(responsedata.cid)
            document.getElementById('returnedCID').innerHTML = responsedata.cid
        }
    });
}

async function addImage(){
    target = document.getElementById('uploadImage')
    const base64Image = await toBase64(target.files[0])
    $.ajax({
        url : '/ipfs',
        type : 'POST',
        data : { 'text' : base64Image },
        success : function(responsedata) {              
            console.log(responsedata.cid)
            document.getElementById('returnedCID').innerHTML = responsedata.cid
        },
        error: function (request, status, error) {
            alert(request.responseText);
        }
    });
}

function getData(cid){
    mycid = document.getElementById('submittedIPFS').value
    $.ajax({
        url : `/ipfs?cid=${mycid}`,
        type : 'GET',
        success : function(responsedata) {              
            console.log(responsedata.data)
            if (responsedata.data.startsWith('data:image')){
                document.getElementById('showImage').setAttribute('src', responsedata.data);
            }
            else {
               document.getElementById('returnedData').innerHTML = responsedata.data 
               document.getElementById('showImage').setAttribute('src', '');
            }
            
        }
    });
}