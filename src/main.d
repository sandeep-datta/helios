//A fake main is required so that _Dmodule_ref reference errors are 
//removed when the DMD compiler inserts required definitions.
//The DMD compiler inserts some initialisation code when it finds the 
//D main function (_Dmain)
//http://stackoverflow.com/questions/7480046/implementing-a-c-api-in-d

void main() {}
