//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/row.dart';
import 'package:sicma/frontEnd/components/form/section.dart';
import 'package:sicma/frontEnd/components/tab/tabView.dart';

class NewScreenHistorial extends StatefulWidget {
  NewScreenHistorial({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewScreenHistorialState createState() => _NewScreenHistorialState();
}

class _NewScreenHistorialState extends State<NewScreenHistorial>
    with TickerProviderStateMixin {
  TabController _tabController;
  Map form = new Map();
  Map data;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
    _fetchData();
  }

  getItems(data) {
    return (data as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  validateText(text) {
    if (text != null) {
      String test = text;
      test = test.split(" ").join('');
      if (test.length == 0) {
        return false;
      }

      return true;
    }
    return false;
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    dynamic response = json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/pacient.json"));
    if (response != null) {
      data = Map.from(response);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Pacient p = ModalRoute.of(context).settings.arguments as Pacient;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: new BorderRadius.only(
                        bottomRight: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    child: IconButton(
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColorLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    "Historial Clínico",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )
              ])),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  // give the tab bar a height [can change hheight to preferred height]
                  Container(
                      height: 45,
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            // first tab [you can add an icon using the icon property]
                            Tab(
                              icon: Icon(Icons.group),
                            ),
                            Tab(
                              icon: Icon(Icons.group),
                            ),
                            Tab(
                              icon: Icon(Icons.group),
                            ),
                            Tab(
                              icon: Icon(Icons.calendar_today),
                            )
                          ],
                        ),
                      )),
                  Expanded(
                      child: Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                            child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  CustomTabView(
                                    title: 'Antecedentes Heredofamiliares',
                                    children: [
                                      CustomField(
                                        label:
                                            'Algún familiar padece las siguientes enfermedades:',
                                        maxLength: 45,
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkboxGroup',
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                      ),
                                      CustomField(
                                        label: 'Otro:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                      ),
                                    ],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Siguente'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title:
                                        'Antecedentes Personales No Patológicos',
                                    children: [
                                      CustomRow(
                                        columns: 2,
                                        children: [
                                          CustomField(
                                            label: 'Aseo diario',
                                            editable: true,
                                            isRequired: false,
                                            type: 'select',
                                            validator: (value) {
                                              return null;
                                            },
                                            items:
                                                getItems(data['denotaciones']),
                                            onChanged: (value) {
                                              form['aseoDiario'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: 'Higiene dental',
                                            editable: true,
                                            isRequired: false,
                                            type: 'select',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['estados']),
                                            onChanged: (value) {
                                              form['higieneDental'] = value;
                                            },
                                          ),
                                        ],
                                      ),
                                      CustomSection(
                                        label: "Dietéticos",
                                        children: [
                                          CustomRow(
                                            children: [
                                              CustomField(
                                                label: 'Apetito',
                                                editable: true,
                                                isRequired: false,
                                                type: 'select',
                                                validator: (value) {
                                                  return null;
                                                },
                                                items:
                                                    getItems(data['valores']),
                                                onChanged: (value) {
                                                  form['apetito'] = value;
                                                },
                                              ),
                                              CustomField(
                                                label: 'Hora de mayor apetito',
                                                editable: true,
                                                isRequired: false,
                                                type: 'select',
                                                validator: (value) {
                                                  return null;
                                                },
                                                items: getItems(data['tiempo']),
                                                onChanged: (value) {
                                                  form['mayorApetito'] = value;
                                                },
                                              ),
                                            ],
                                            columns: 2,
                                          ),
                                          CustomField(
                                            label:
                                                'Realiza las siguientes comidas:',
                                            maxLength: 45,
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkboxGroup',
                                            items: getItems(data['comidas']),
                                          ),
                                          CustomRow(
                                            children: [
                                              CustomField(
                                                label: '¿Dónde come?',
                                                editable: true,
                                                isRequired: false,
                                                type: 'select',
                                                validator: (value) {
                                                  return null;
                                                },
                                                items: getItems(data['lugar']),
                                                onChanged: (value) {
                                                  form['apetito'] = value;
                                                },
                                              ),
                                              CustomField(
                                                label: '¿Con quíen come?',
                                                editable: true,
                                                isRequired: false,
                                                type: 'select',
                                                validator: (value) {
                                                  return null;
                                                },
                                                items:
                                                    getItems(data['compania']),
                                                onChanged: (value) {
                                                  form['mayorApetito'] = value;
                                                },
                                              ),
                                            ],
                                            columns: 2,
                                          ),
                                          CustomRow(
                                            children: [
                                              CustomField(
                                                label: '¿Quíen prepara?',
                                                editable: true,
                                                isRequired: false,
                                                type: 'select',
                                                validator: (value) {
                                                  return null;
                                                },
                                                items: getItems(
                                                    data['preparador']),
                                                onChanged: (value) {
                                                  form['apetito'] = value;
                                                },
                                              ),
                                              Container()
                                            ],
                                            columns: 2,
                                          ),
                                          CustomField(
                                            label:
                                                '¿Suele comer a la misma hora?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            onChanged: (value) {
                                              form['comerMismaHora'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Suele saltarse comidas?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            onChanged: (value) {
                                              form['saltarseComidas'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                'De las siguientes preparaciónes cuales lleva a cabo en sus alimentos',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkboxGroup',
                                            validator: (value) {
                                              return null;
                                            },
                                            items:
                                                getItems(data['preparaciones']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Con qué grasas cocina sus alimentos?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkboxGroup',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['grasas']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Agrega sal a la comida ya preparada?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿A qué alimentos es intolerante?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿A qué alimentos no son de su agrado?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Qué alimentos no le apetecen?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Qué liquidos ingiere?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'number',
                                            orientation: 'horizontal',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Su consumo varia cuando esta triste, ansioso o nervioso',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Ha modificado su alimentación en el último semestre?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: 'Causa',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Utiliza azúcar, crema, leche o sustitutos agregados en sus bebidas?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Ingiere alcohol?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Consume tabaco?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Toma o ha tomado algún medicamento para bajar de peso?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Cúales?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            onChanged: (value) {
                                              form['medicamentos'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label:
                                                '¿Consume suplementos o complementos en su dieta diaria?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'checkbox',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: '¿Cúales?',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            onChanged: (value) {
                                              form['medicamentos'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: 'Valoración Nutricional:',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['valores']),
                                            onChanged: (value) {
                                              form['apetito'] = value;
                                            },
                                          ),
                                        ],
                                      ),
                                      if (p.data['tipoConsulta'] == 'Deportivo')
                                        CustomSection(
                                          label: "Deportivos",
                                          children: [
                                            CustomField(
                                              label:
                                                  'Edad desde la que se práctica deporte',
                                              editable: true,
                                              isRequired: false,
                                              type: 'text',
                                              orientation: 'horizontal',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '¿Es sedentario?',
                                              editable: true,
                                              isRequired: false,
                                              type: 'checkbox',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  'Deportes practicados anteriormente:',
                                              editable: true,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  'Deportes que le es imposible practicar:',
                                              editable: true,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  'Malestares generados al hacer deporte:',
                                              editable: true,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  '¿Ingiére liquidos mientras practica deporte?',
                                              editable: true,
                                              isRequired: false,
                                              type: 'checkbox',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  '¿Ha tenido problemas de desidratación por insolación?',
                                              editable: true,
                                              isRequired: false,
                                              type: 'checkbox',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label:
                                                  '¿Suele tener más sed, más hambre o más ganas de orinar de lo habitual?',
                                              editable: true,
                                              isRequired: false,
                                              type: 'checkbox',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['valores']),
                                              onChanged: (value) {
                                                form['apetito'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Siguiente'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title:
                                        'Antecedentes Personales Patológicos',
                                    children: [
                                      CustomRow(
                                        columns: 2,
                                        children: [
                                          CustomField(
                                            label: 'Tipo de sangre',
                                            editable: true,
                                            isRequired: false,
                                            type: 'select',
                                            validator: (value) {
                                              return null;
                                            },
                                            items:
                                                getItems(data['grupoSangre']),
                                            onChanged: (value) {
                                              form['escolaridad'] = value;
                                            },
                                          ),
                                          CustomField(
                                            label: 'RH',
                                            editable: true,
                                            isRequired: false,
                                            type: 'select',
                                            validator: (value) {
                                              return null;
                                            },
                                            items: getItems(data['rh']),
                                            onChanged: (value) {
                                              form['escolaridad'] = value;
                                            },
                                          ),
                                        ],
                                      ),
                                      CustomField(
                                        label: 'Transfusiones de sangre',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkbox',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['rh']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: 'Motivo:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            'Perido de la última transfusión:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: '¿Sufre desmayos?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkbox',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            '¿Le han realizado alguna operación?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkbox',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: 'Operaciones:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            '¿Tiene alguno de los siguientes padecimientos?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkboxGroup',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(
                                            data['enfermedades']['personales']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            '¿Ha estado internada recientemente?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkbox',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['escolaridad']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: '¿Padece de alergías?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'checkbox',
                                        validator: (value) {
                                          return null;
                                        },
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            '¿A qué medicamentos es alérgico?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: '¿A qué alimentos es alérgico?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label: '¿Qué otras alérgias padece?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      CustomField(
                                        label:
                                            '¿Padece alguna de las siguientes lesiones?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        validator: (value) {
                                          return null;
                                        },
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                        onChanged: (value) {
                                          form['escolaridad'] = value;
                                        },
                                      ),
                                      /*if (p.data['tipoConsulta'] == 'Deportiva')*/
                                      CustomSection(
                                          label: "Fisicos",
                                          children: [
                                            CustomField(
                                              label:
                                                  '¿Ha sufrido alguna de las siguientes lesiones?',
                                              editable: true,
                                              isRequired: false,
                                              type: 'checkboxGroup',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['lesiones']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ]),
                                      if (p.data['sexo'] == 'Femenino')
                                        CustomSection(
                                          label: "Ginecobstetricos",
                                          children: [
                                            CustomField(
                                              label: '¿Ha iniciado a mestruar?',
                                              editable: true,
                                              isRequired: false,
                                              keyName: 'inicioMenarca',
                                              type: 'checkbox',
                                              validator: (value) {
                                                return null;
                                              },
                                              onChanged: (value) {
                                                form['inicioMenarca'] = value;
                                              },
                                            ),
                                            //if (form['inicioMenarca'] ?? false)
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'Edad de inicio',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'number',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['escolaridad']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: 'No. de gestaciones',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['escolaridad']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                            //if (form['inicioMenarca'] ?? false)
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'No. de abortos',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['escolaridad']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: 'No. de cesareas',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['escolaridad']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            form['paciente_id'] = p.id;
                                            form['fecha'] =
                                                DateTime.now().toString();
                                            print(form.toString());
                                            var hD = new HistoryDao();
                                            hD.insert(new History(
                                                id: null,
                                                data: Map.from(form)));
                                            print('ya');
                                            _tabController.index++;
                                          },
                                          child: Text('Guardar'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Consultas',
                                    children: [
                                      /*IconButton(
                                            icon: Icon(Icons.filter_list),
                                            onPressed: null),*/
                                      RaisedButton.icon(
                                        icon: Icon(Icons.add),
                                        label: Text('Nueva consulta'),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              "/Consulta/New",
                                              arguments: p);
                                        },
                                      ),
                                    ],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {}
                                          },
                                          child: Text('Finalizar'))
                                    ],
                                  ),
                                ]),
                          )))
                ],
              ),
            ),
    );
  }
}
