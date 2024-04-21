import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen ({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();

}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String number1="";
  String operand="";
  String number2="";
  bool isDarkMode= false;

  @override
  Widget build(BuildContext context) {
    final screenSize= MediaQuery.of(context).size;
    return Scaffold(
      body:SafeArea(
        bottom: false,
        child: Column(
          children: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  // Implement your dark mode logic here
                });
              },
            ),
            //output area
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text("$number1$operand$number2"
                             .isEmpty?"0":
                              "$number1$operand$number2",
                    style: const TextStyle(

                    fontSize: 48,
                    fontWeight: FontWeight.bold,

                  ),
                    textAlign: TextAlign.end,

                    ),
                ),
              ),
            ),

            // input button area
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                  width:value == Btn.calculate? screenSize.width/2:
                  (screenSize.width/4),
                  height: (screenSize.width/5 ),
                  child: buildButton(value)),).
              toList(),
            )
          ],
        ),
      )
    );


  }
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape:OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.white24)
        ),
         child:InkWell(
            onTap: () => onBtnTap(value),
            child: Center(child: Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 22),))),
      ),
    );

  }

  void onBtnTap(String value) {
    if(value == Btn.del){
      delete();
      return;

    }
    if(value == Btn.clr){
      clear();
      return;
    }
    if(value == Btn.per){
      convertPercentage();
      return;
    }
    if(value == Btn.calculate){
      calculateValue();
      return;
    }
    appendValue(value);

  }
  void delete(){
    if (number2.isNotEmpty){
      number2 = number2.substring(0,number2.length-1);
    }else if(operand.isNotEmpty){
      operand="";
    }else{
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {});
  }
  void clear(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }
  void convertPercentage(){
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){

      calculateValue();

    }
    if(operand.isNotEmpty) {
      return;
    }
    final number= double.parse(number1);
    setState(() {
      number1= "${(number / 100)}";
      operand= "";
      number2= "";
    });
  }

  void calculateValue(){
    if(number1.isEmpty || operand.isEmpty || number2.isEmpty ) return;
    final double num1= double.parse(number1);
    final double num2= double.parse(number2);

    var res= 0.0;
    switch(operand){
      case Btn.add:
        res= num1+num2;
        break;

      case Btn.subtract:
        res= num1-num2;
        break;
      case Btn.multiply:
        res= num1*num2;
        break;
      case Btn.divided:
        res = num1/num2;
        break;
        default:
    }
    setState(() {
      number1= "$res";

      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }
      operand="";
      number2="";
    });
  }

  void appendValue(String value){
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateValue();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }



  Color getBtnColor(value){
    return [Btn.del, Btn.clr].contains(value)?Colors.cyan.shade800:
      [Btn.calculate].contains(value)?Colors.teal:[
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divided,
      ].contains(value)?Colors.deepOrange:
      Colors.lightBlueAccent;

  }
}
