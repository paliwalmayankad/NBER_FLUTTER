class CommonModels{
  String status;
  String message;
  String response;


  String username;

  CommonModels.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];

      this.message = obj["message"];


    }


  }




}
