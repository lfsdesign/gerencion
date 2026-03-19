import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; 
import 'package:flutter/services.dart'; 
import '../controllers/cliente_controller.dart';

class CadastroClientesPage extends StatelessWidget {
  CadastroClientesPage({super.key});

  // Máscaras para os campos fixos
  final maskCep = MaskTextInputFormatter(mask: "#####-###", filter: {"#": RegExp(r'[0-9]')});
  final maskTelefone = MaskTextInputFormatter(mask: "(##) # ####-####", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClientesController());
    
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2A), 
      appBar: AppBar(
        title: const Text("CADASTRO DE CLIENTES", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Inter')),
        backgroundColor: const Color(0xFF40403F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "DADOS PRINCIPAIS",
              content: [
                _buildField("RAZÃO SOCIAL", controller.razaoSocialController, hint: ""),
                
                const SizedBox(height: 10),

                // --- SELETOR: CNPJ NA ESQUERDA E PRIMEIRO ---
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("CNPJ", style: TextStyle(
                      color: controller.tipoPessoa.value == "CNPJ" ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'
                    )),
                   // --- BOTÃO MAIS FINO E PROPORCIONAL ---
                    Transform.scale(
                      scale: 0.8, 
                      child: Switch(
                        value: controller.tipoPessoa.value == "CPF",
                        activeTrackColor: Colors.blue,
                        onChanged: (v) {
                          controller.tipoPessoa.value = v ? "CPF" : "CNPJ";
                          controller.cnpjController.clear();
                        },
                      ),
                    ),
                    Text("CPF", style: TextStyle(
                      color: controller.tipoPessoa.value == "CPF" ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'
                    )),
                  ],
                )),

                const SizedBox(height: 10),

                // --- CAMPO DINÂMICO COM MÁSCARAS E VALIDAÇÃO ---
                Obx(() {
                  final mCpf = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
                  final mCnpj = MaskTextInputFormatter(mask: "##.###.###/####-##", filter: {"#": RegExp(r'[0-9]')});

                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildField(
              controller.tipoPessoa.value,
              controller.cnpjController,
              autofocus: true, // 🎯 Fixa o cursor aqui ao abrir a tela
              hint: controller.tipoPessoa.value == "CNPJ"
                  ? "00.000.000/0000-00"
                  : "000.000.000-00",
              inputFormatters: [
                controller.tipoPessoa.value == "CNPJ" ? mCnpj : mCpf
              ],
              onChanged: (v) {
                // AJUSTE AQUI: Mantendo sua lógica original de busca
                if (controller.tipoPessoa.value == "CNPJ") {
                  controller.buscarCNPJ(v);
                } else {
                  controller.validarCPF(v);
                }
              },
            ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildField("INSCR. ESTADUAL", controller.ieController, hint: ""),
                      ),
                    ],
                  );
                }),

                _buildField("NOME FANTASIA", controller.nomeFantasiaController),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "CONTATO",
              content: [
                _buildField("E-MAIL", controller.emailController, hint: "email@exemplo.com"),
                _buildField("TELEFONE / WHATSAPP", controller.telefoneController, hint: "(00) 0 0000-0000", inputFormatters: [maskTelefone]),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "ENDEREÇO",
              content: [
                Row(
                  children: [
                    Expanded(child: _buildField("CEP", controller.cepController, hint: "00000-000", inputFormatters: [maskCep], onChanged: (v) => controller.buscarCEP(v))),
                    const SizedBox(width: 10),                 
                    Expanded(flex: 2, child: _buildField("CIDADE", controller.cidadeController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildField("ENDEREÇO", controller.enderecoController)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildField("N°", controller.numeroController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildField("BAIRRO", controller.bairroController)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildField("UF", controller.ufController)),
                  ],
                ),
                _buildField("ENDEREÇO DE ENTREGA", controller.entregaController, hint: "COMPLEMENTO..."),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "OBSERVAÇÕES",
              content: [
                _buildField("NOTAS", controller.obsController, maxLines: 3),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.salvarCliente(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("SALVAR CLIENTE", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2A), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF40403F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.blue[400], fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Inter')),
          const SizedBox(height: 10),
          ...content,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1, Function(String)? onChanged, List<TextInputFormatter>? inputFormatters, bool autofocus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          const SizedBox(height: 5),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            autofocus: autofocus,
            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14, fontFamily: 'Inter'),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}