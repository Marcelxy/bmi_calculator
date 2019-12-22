import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BmiCalculator extends StatefulWidget {
  @override
  _BmiCalculatorState createState() => _BmiCalculatorState();
}

enum Formula { metrisch, englisch }
enum Gender { maennlich, weiblich }

class _BmiCalculatorState extends State<BmiCalculator> {
  final _formKey = new GlobalKey<FormState>();

  int _genderGroup = 0;
  int _formulaGroup = 0;
  int _age = 0;
  double _weight = 0.0;
  double _height = 0.0;
  double _bmiValue = 0.0;
  String _bmiResult = "";
  String _weightLabelText = "Gewicht in vollen kg";
  String _heightLabelText = "Größe in cm";
  String _perfectBMI = "";
  Formula _formula = Formula.metrisch;
  Gender _gender = Gender.maennlich;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/bmilogo.png", height: 100, width: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<int>(
                  value: 0,
                  groupValue: _formulaGroup,
                  onChanged: _handleFormulaGroupChanged,
                ),
                Text(
                  "Metrisch",
                ),
                Radio<int>(
                  value: 1,
                  groupValue: _formulaGroup,
                  onChanged: _handleFormulaGroupChanged,
                ),
                Text(
                  "Englisch",
                ),
              ],
            ),
            Card(
              margin: EdgeInsets.all(18.0),
              elevation: 8.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 5.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bitte gib dein Alter ein.";
                          } else if (int.parse(value) < 19) {
                            return "BMI Berechnung erst ab 19 Jahren gültig.";
                          } else {
                            _age = int.parse(value);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Alter",
                            contentPadding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.person))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 5.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bitte gib dein Gewicht ein.";
                          } else {
                            _weight = double.parse(value);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: _weightLabelText,
                            contentPadding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.line_weight))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bitte gib deine Größe ein.";
                          } else {
                            _height = double.parse(value);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: _heightLabelText,
                            contentPadding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.assessment))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<int>(
                        value: 0,
                        groupValue: _genderGroup,
                        onChanged: _handleGenderGroupChanged,
                      ),
                      Text(
                        "Männlich",
                      ),
                      Radio<int>(
                        value: 1,
                        groupValue: _genderGroup,
                        onChanged: _handleGenderGroupChanged,
                      ),
                      Text(
                        "Weiblich",
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: RaisedButton(
                      onPressed: () => _calculateBMI(),
                      color: Colors.deepOrange.shade300,
                      child: Text("Berechnen",
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "Dein BMI: ${_bmiValue.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "$_bmiResult",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "Optimaler BMI: $_perfectBMI",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Quelle: https://www.epic4health.com/bmiformula.html
   */
  void _calculateBMI() {
    setState(() {
      if (_formKey.currentState.validate()) {
        if (_formula == Formula.metrisch) {
          _bmiValue = (_weight / (_height * _height)) * 10000;
        } else {
          _bmiValue = (_weight / (_height * _height)) * 703;
        }
        _getBMIResult();
        _getPerfectBMI();
      }
    });
  }

  void _getBMIResult() {
    if (_age >= 19 && _age < 25) {
      if (_bmiValue < 19) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 19 && _bmiValue < 24) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 24 && _bmiValue < 29) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 29 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    } else if (_age >= 25 && _age < 35) {
      if (_bmiValue < 20) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 20 && _bmiValue < 25) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 25 && _bmiValue < 30) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 30 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    } else if (_age >= 35 && _age < 45) {
      if (_bmiValue < 21) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 21 && _bmiValue < 26) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 26 && _bmiValue < 31) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 31 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    } else if (_age >= 45 && _age < 55) {
      if (_bmiValue < 22) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 22 && _bmiValue < 27) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 27 && _bmiValue < 32) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 32 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    } else if (_age >= 55 && _age < 65) {
      if (_bmiValue < 23) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 23 && _bmiValue < 28) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 28 && _bmiValue < 33) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 33 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    } else if (_age >= 65) {
      if (_bmiValue < 24) {
        _bmiResult = "Untergewichtig";
      } else if (_bmiValue >= 24 && _bmiValue < 29) {
        _bmiResult = "Normalgewichtig";
      } else if (_bmiValue >= 29 && _bmiValue < 34) {
        _bmiResult = "Übergewichtig";
      } else if (_bmiValue >= 34 && _bmiValue < 40) {
        _bmiResult = "Adipositas";
      } else if (_bmiValue >= 40) {
        _bmiResult = "Starke Adipositas";
      }
    }
  }

  /*
  Quelle: https://www.bmi-tabellen.de/
   */
  void _getPerfectBMI() {
    if (_gender == Gender.maennlich) {
      if (_age >= 19 && _age < 25) {
        _perfectBMI = "19 - 24";
      } else if (_age >= 25 && _age < 35) {
        _perfectBMI = "20 - 25";
      } else if (_age >= 35 && _age < 45) {
        _perfectBMI = "21 - 26";
      } else if (_age >= 45 && _age < 55) {
        _perfectBMI = "22 - 27";
      } else if (_age >= 55 && _age < 65) {
        _perfectBMI = "23 - 28";
      } else if (_age >= 65) {
        _perfectBMI = "24 - 29";
      }
    } else if (_gender == Gender.weiblich) {
      if (_age >= 19 && _age < 25) {
        _perfectBMI = "18 - 23";
      } else if (_age >= 25 && _age < 35) {
        _perfectBMI = "19 - 24";
      } else if (_age >= 35 && _age < 45) {
        _perfectBMI = "20 - 25";
      } else if (_age >= 45 && _age < 55) {
        _perfectBMI = "21 - 26";
      } else if (_age >= 55 && _age < 65) {
        _perfectBMI = "22 - 27";
      } else if (_age >= 65) {
        _perfectBMI = "23 - 28";
      }
    }
  }

  void _handleGenderGroupChanged(int value) {
    setState(() {
      _genderGroup = value;
      switch (_genderGroup) {
        case 0:
          _gender = Gender.maennlich;
          break;
        case 1:
          _gender = Gender.weiblich;
          break;
        default:
          print("Radio Button Geschlechtsgruppe ist falsch konfiguriert.");
      }
    });
  }

  void _handleFormulaGroupChanged(int value) {
    setState(() {
      _formulaGroup = value;
      _bmiValue = 0.0;
      _bmiResult = "";
      _perfectBMI = "";
      _formKey.currentState.reset();
      switch (_formulaGroup) {
        case 0:
          _formula = Formula.metrisch;
          _weightLabelText = "Gewicht in vollen kg";
          _heightLabelText = "Größe in cm";
          break;
        case 1:
          _formula = Formula.englisch;
          _weightLabelText = "Gewicht in vollen Pfund";
          _heightLabelText = "Größe in Fuß";
          break;
        default:
          print("Radio Button Formel Gruppe ist falsch konfiguriert.");
      }
    });
  }
}
