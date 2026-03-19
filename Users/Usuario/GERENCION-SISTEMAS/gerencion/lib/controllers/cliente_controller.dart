import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart'; // <--- ADICIONE ESTA LINHA NO TOPO

class ClientesController extends GetxController {
  // Mude para esta forma exata:
  var listaClientes = <Map<String, dynamic>>[].obs;

  var tipoPessoa = "CNPJ".obs; // Isso cria a chave que o GetX entende

void salvarCliente() async {
    try {
      isLoading.value = true;

      final novoCliente = {
        "nome": razaoSocialController.text.toUpperCase(),
        "nomeFantasia": nomeFantasiaController.text.toUpperCase(), // <-- ADICIONE ESTA LINHA
        "cpfCnpj": cnpjController.text,
        "cidade": cidadeController.text.toUpperCase(),
      };
      
      listaClientes.add(novoCliente); // Agora ele vai achar a lista lá no topo!

      Get.back();
      Get.snackbar("Sucesso", "Cliente cadastrado!");
    } catch (e) {
      debugPrint("Erro: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  // Controladores de texto para CADA campo do seu formulário Next.js
  final razaoSocialController = TextEditingController();
  final cnpjController = TextEditingController();
  final nomeFantasiaController = TextEditingController();
  final ieController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cepController = TextEditingController();
  final enderecoController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();
  final entregaController = TextEditingController();
  final obsController = TextEditingController();

  var isLoading = false.obs;


  // BUSCA CNPJ (Igual ao seu handleCNPJ do Next.js)
  Future<void> buscarCNPJ(String cnpj) async {
    String cleanCnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // 1. SE APAGAR O CNPJ, LIMPA TODOS OS CAMPOS
    if (cleanCnpj.isEmpty) {
      razaoSocialController.clear();
      nomeFantasiaController.clear();
      enderecoController.clear();
      numeroController.clear();
      bairroController.clear();
      cidadeController.clear();
      ufController.clear();
      cepController.clear();
      return; 
    }

    // 2. BUSCA AUTOMÁTICA AO DIGITAR OS 14 NÚMEROS
    if (cleanCnpj.length == 14) {
      isLoading.value = true;
      try {
        final response = await http.get(Uri.parse('https://publica.cnpj.ws/cnpj/$cleanCnpj'));
        
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          
          razaoSocialController.text = data['razao_social']?.toString().toUpperCase() ?? '';
          nomeFantasiaController.text = (data['estabelecimento']['nome_fantasia'] ?? data['razao_social'])?.toString().toUpperCase() ?? '';
          enderecoController.text = "${data['estabelecimento']['tipo_logradouro']} ${data['estabelecimento']['logradouro']}".toUpperCase();
          numeroController.text = data['estabelecimento']['numero'] ?? '';
          bairroController.text = data['estabelecimento']['bairro']?.toString().toUpperCase() ?? '';
          cidadeController.text = data['estabelecimento']['cidade']['nome']?.toString().toUpperCase() ?? '';
          ufController.text = data['estabelecimento']['estado']['sigla']?.toString().toUpperCase() ?? '';
          // Substitua a sua linha 90 por este bloco:
// Substitua as linhas 91 a 95 por isto:
String cepBruto = data['estabelecimento']?['cep']?.toString() ?? '';
if (cepBruto.length == 8) {
  // Formata manualmente: 12345678 -> 12345-678
  cepController.text = "${cepBruto.substring(0, 5)}-${cepBruto.substring(5)}";
} else {
  cepController.text = cepBruto;
}
          Get.snackbar("Sucesso", "Dados do CNPJ carregados!", 
            backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        } else {
          // TARJA VERMELHA - CNPJ NÃO ENCONTRADO
          Get.snackbar("CNPJ Inválido", "Corrija os dados ou verifique o número!", 
            backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar("Erro", "Falha ao conectar no servidor.", 
          backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    }
  }
 Future<void> buscarCEP(String cep) async {
    String cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanCep.isEmpty) {
      enderecoController.clear();
      bairroController.clear();
      cidadeController.clear();
      ufController.clear();
      return;
    }

    if (cleanCep.length == 8) {
      try {
        final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cleanCep/json/'));
        final data = json.decode(response.body);

        // 1. TRAVA DE ERRO: Se a API retornar erro ou for nula
        if (data == null || data['erro'] == true || data['logradouro'] == null) {
          Get.snackbar(
            "CEP Não Encontrado", 
            "O número digitado não existe.",
            backgroundColor: Colors.red, 
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          
          // Limpamos tudo para não sobrar lixo na tela
          enderecoController.clear();
          bairroController.clear();
          cidadeController.clear();
          ufController.clear();
          return; // AQUI ELE PARA TUDO E NÃO CHEGA NO VERDE
        }

        // 2. SUCESSO: Só chega aqui se passar pela trava acima
        enderecoController.text = data['logradouro']?.toString().toUpperCase() ?? '';
        bairroController.text = data['bairro']?.toString().toUpperCase() ?? '';
        cidadeController.text = data['localidade']?.toString().toUpperCase() ?? '';
        ufController.text = data['uf']?.toString().toUpperCase() ?? '';
        
        Get.snackbar(
          "CEP Encontrado", 
          "Endereço preenchido com sucesso!",
          backgroundColor: Colors.green, 
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

      } catch (e) {
        Get.snackbar(
          "Falha na Busca", 
          "Não foi possível validar o CEP agora.",
          backgroundColor: Colors.orange, 
          colorText: Colors.white,
        );
        }
      }
    }

void validarCPF(String cpf) {
  String limpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
  
  // 2. Só faz a conta se tiver os 11 números completos
  if (limpo.length >= 11) { // Mudamos == para >= por segurança
    if (CPFValidator.isValid(cpf)) {
      // CPF Matemático Real
      Get.snackbar("Documento Ok", "O CPF digitado é válido.",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      // CPF Inventado (Matemática não bate)
      Get.snackbar("CPF Inválido", "Este número de CPF não é real.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

  }