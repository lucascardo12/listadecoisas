import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listadecoisa/controller/cadastro-controller.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:listadecoisa/widgets/Button-text-padrao.dart';
import 'package:listadecoisa/widgets/compo-padrao.dart';

class Cadastro extends GetView {
  final gb = Get.find<Global>();
  final ct = Get.put(CadastroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            gb.getPrimary(),
            gb.getSecondary(),
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              )),
          CampoPadrao(
            hintText: 'E-mail',
            controller: ct.loginControler,
          ),
          SizedBox(height: 10),
          Obx(() => CampoPadrao(
                hintText: 'Senha',
                lObescure: ct.lObescure.value,
                suffixIcon: IconButton(
                  color: Colors.white,
                  icon: Icon(ct.lObescure.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => ct.lObescure.value = !ct.lObescure.value,
                ),
                controller: ct.senhaControler,
              )),
          SizedBox(height: 10),
          CampoPadrao(
            hintText: 'Nome',
            controller: ct.nomeControler,
          ),
          SizedBox(height: 20),
          ButtonTextPadrao(
            label: 'Cadastro',
            color: gb.getWhiteOrBlack(),
            textColor: gb.getPrimary(),
            onPressed: () => ct.valida(),
          ),
          ButtonTextPadrao(
            label: 'Voltar',
            textColor: Colors.white,
            color: Colors.transparent,
            onPressed: () => Get.back(),
          )
        ],
      ),
    ));
  }
}
