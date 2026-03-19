import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/produto_controller.dart';

class CadastroProdutoPage extends StatelessWidget {
  const CadastroProdutoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProdutoController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cadastro de Produtos"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ÁREA DA FOTO
            Center(
              child: GestureDetector(
                onTap: () => _mostrarOpcoesFoto(context, controller),
                child: Obx(() => Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueAccent.withAlpha(128)),
                  ),
                  child: controller.imagemBytes.value == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.blueAccent, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Adicionar Foto",
                              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Ideal: 500x500 px",
                              style: TextStyle(color: Colors.white38, fontSize: 10),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            controller.imagemBytes.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                )),
              ),
            ),
            const SizedBox(height: 30),

            // CAMPOS DE TEXTO (Ocupando a largura total como nos Clientes)
            _buildTextField(controller.nomeController, "Nome do Produto/Item"),
            const SizedBox(height: 15),
            
            Row(
              children: [
                Expanded(child: _buildTextField(controller.unidadeController, "Unidade (KG, UN, CX)")),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(controller.precoVendaController, "Preço", keyboardType: TextInputType.number)),
              ],
            ),
            
            const SizedBox(height: 15),
            _buildTextField(controller.descricaoController, "Descrição/Observações", maxLines: 3),
            
            const SizedBox(height: 40),

            // BOTÃO CADASTRAR
            ElevatedButton(
              onPressed: () => controller.salvarNoGerencion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "CADASTRAR",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
    );
  }

  void _mostrarOpcoesFoto(BuildContext context, ProdutoController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.white),
            title: const Text("Tirar Foto", style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.back();
              controller.tirarFoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text("Galeria", style: TextStyle(color: Colors.white)),
            onTap: () {
              Get.back();
              controller.tirarFoto(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}