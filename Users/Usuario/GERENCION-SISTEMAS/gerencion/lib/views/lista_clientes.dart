import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cliente_controller.dart';
import 'cadastro_cliente.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({super.key});

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  final ClientesController controller = Get.put(ClientesController());
  final TextEditingController searchController = TextEditingController();
  bool estaPesquisando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clientes",
              style: GoogleFonts.inter(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold),
            ),
            Obx(() => Text(
                  "${controller.listaClientes.length} clientes",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                )),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          // BOTAO DE 3 PONTINHOS NO LUGAR CERTO (ACTIONS)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF1A1A1A),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onSelected: (value) {
              if (value == 'novo_cliente') {
                Get.to(() =>  CadastroClientesPage());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'novo_cliente',
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.blue, size: 20),
                    SizedBox(width: 12),
                    Text("Novo Cliente", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)));
        }

        return Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: ListView.builder(
                itemCount: controller.listaClientes.length,
                itemBuilder: (context, index) {
                  final cliente = controller.listaClientes[index];
                  return Card(
                    color: const Color(0xFF2C2C2C),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _mostrarDetalhesCliente(context, cliente),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Color(0xFF1A73E8),
                          size: 24,
                        ),
                      ),
                      title: Transform.translate(
                        offset: const Offset(20, 0),
                        child: Text(
                          "${index + 100} • ${cliente['nome'] ?? 'SEM RAZÃO SOCIAL'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      subtitle: Transform.translate(
                        offset: const Offset(20, 0),
                        child: Text(
                          cliente['nomeFantasia'] ?? "NOME FANTASIA NÃO INFORMADO",
                          style: TextStyle(color: Colors.grey[400], fontSize: 11),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A73E8),
        onPressed: () => Get.to(() => CadastroClientesPage()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDetalhesCliente(BuildContext context, cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(cliente['nome'] ?? 'Detalhes', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CPF/CNPJ: ${cliente['cpfCnpj'] ?? 'N/I'}", style: const TextStyle(color: Colors.grey)),
            Text("Cidade: ${cliente['cidade'] ?? 'N/I'}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A73E8)),
                onPressed: () => Navigator.pop(context),
                child: const Text("NOVO PEDIDO", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}