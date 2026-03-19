import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ProdutoController extends GetxController {
  // Campos Universais (não importa o que você venda)
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController(); // Detalhes extras
  final precoVendaController = TextEditingController();
  final unidadeController = TextEditingController(); // Ex: Kg, Un, Cx
  
  // Controle de Ecossistema (O "Cadeado")
  // Se for 'true', o usuário pode editar. Se 'false', vem travado da empresa.
  var podeEditar = true.obs; 

  // Parte da Imagem
  var imagemPath = "".obs; 
  final ImagePicker _picker = ImagePicker();
  var imagemBytes = Rxn<Uint8List>();

  // Função para capturar a foto
  // Substitua da linha 23 até a 33 por isto:
  Future<void> tirarFoto(ImageSource source) async {
    // Mantendo sua lógica de Ecossistema (Cadeado)
    if (!podeEditar.value) {
      Get.snackbar("Acesso Restrito", "Este produto é gerenciado pela empresa.");
      return;
    }

    final XFile? image = await _picker.pickImage(source: source);
    
    if (image != null) {
      // Isso aqui é o que mata a tela vermelha no Desktop/Web
      final bytes = await image.readAsBytes();
      imagemBytes.value = bytes; 
      imagemPath.value = image.path; // Mantemos o path para o mobile tbm
    }
  }

  void limparCampos() {
    nomeController.clear();
    descricaoController.clear();
    precoVendaController.clear();
    unidadeController.clear();
    imagemPath.value = "";
  }

  void salvarNoGerencion() {
    // Lógica futura para salvar no banco de dados
    Get.snackbar("Sucesso", "${nomeController.text} adicionado ao Gerencion!");
    limparCampos();
  }
}