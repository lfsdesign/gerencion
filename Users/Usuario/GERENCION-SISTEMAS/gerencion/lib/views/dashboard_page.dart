import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_clientes.dart';
import 'cadastro_produto_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeGerencion extends StatelessWidget {
  final String nomeUsuario;
  final String empresaUsuario;
  const HomeGerencion({super.key, required this.nomeUsuario, required this.empresaUsuario});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF2B2B2A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: const Color(0xFF2B2B2A),
          elevation: 0,
          shadowColor: const Color(0xFF1A73E8),
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Stack(
              children: [
                Transform.translate(
                  offset: const Offset(0, 1),
                  child: Center(
                    child: OverflowBox(
                      maxHeight: 150,
                      maxWidth: 150,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 85),
                    child: InkWell(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu, color: Color(0xFF1A73E8), size: 24),
                          const SizedBox(width: 10),
                          Text(
                            "Início",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1A73E8),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          _buildDashCards(context),
          
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Análise de Desempenho", 
              style: GoogleFonts.inter(
                color: Colors.white70, 
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF40403F),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, color: Color(0xFF1A73E8), size: 40),
                  SizedBox(height: 10),
                  Text("Gráfico de Vendas (Em breve)", 
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ] 
      ),
    );
  }

  Widget _buildDashCards(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    int colunas = largura < 600 ? 2 : (largura < 1100 ? 3 : 6);
    double proporcao = largura < 600 ? 2.1 : (largura < 1100 ? 2.0 : 2.5);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: colunas,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: proporcao,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final cards = [
          _cardSimples("Vendas Hoje", "R\$ 2.500", Icons.monetization_on, Colors.green),
          _cardSimples("Pedidos", "12", Icons.shopping_cart, Colors.blue),
          _cardSimples("Clientes", "45", Icons.people, Colors.orange),
          _cardSimples("Meta Mês", "75%", Icons.trending_up, Colors.purple),
          _cardSimples("Novos", "03", Icons.person_add, Colors.teal),
          _cardSimples("Comissão", "******", Icons.lock, Colors.red),
        ];
        return cards[index];
      },
    );
  }

  Widget _cardSimples(String titulo, String valor, IconData icone, Color corIcone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF40403F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icone, color: corIcone, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, 
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 10)),
                Text(valor, 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2B2B2A),
      child: Column(
        children: [
        Container(
  // REDUZI o top de 50 para 40 e o bottom de 20 para 15 para o azul diminuir
  padding: const EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
  color: const Color(0xFF1A73E8), 
  width: double.infinity,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center, // Logo continua no meio
    children: [
      SvgPicture.asset(
        'assets/images/icone.svg', 
        height: 120, // Mantive o seu 120
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 10), // Espaço menor entre logo e texto

      // AGORA OS TEXTOS:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha texto com texto
        children: [
          Text(
            "Empresa: $empresaUsuario", 
            overflow: TextOverflow.ellipsis, 
            maxLines: 1, 
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13) // Fonte levemente menor
          ),
          Text(
            "Usuário: $nomeUsuario", 
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)
          ),
        ],
      ),
    ],
  ),
),
        Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
              _ItemMenu(
                icone: Icons.home,
                titulo: "Início",
                onTap: () => Navigator.pop(context),
              ),
              _ItemMenu(
                icone: Icons.people,
                titulo: "Clientes",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListaClientes()));
                },
              ),
              _ItemMenu(
                icone: Icons.inventory_2_outlined,
                titulo: "Produtos",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroProdutoPage()));
                },
              ),
              _ItemMenu(icone: Icons.shopping_cart, titulo: "Pedidos", onTap: () {}),
              _ItemMenu(icone: Icons.search, titulo: "Consultas", onTap: () {}),
              _ItemMenu(icone: Icons.analytics, titulo: "Status", onTap: () {}),
              _ItemMenu(icone: Icons.assignment, titulo: "Atividades", onTap: () {}),
              _ItemMenu(icone: Icons.settings, titulo: "Configurações", onTap: () {}),
              _ItemMenu(icone: Icons.message, titulo: "Mensagens", onTap: () {}),
              _ItemMenu(icone: Icons.build, titulo: "Ferramentas", onTap: () {}),
              _ItemMenu(icone: Icons.school, titulo: "Tutoriais", onTap: () {}),
              _ItemMenu(icone: Icons.info, titulo: "Sobre", onTap: () {}),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}

class _ItemMenu extends StatefulWidget {
  final IconData icone;
  final String titulo;
  final VoidCallback? onTap;
  const _ItemMenu({required this.icone, required this.titulo, this.onTap});
  @override
  State<_ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<_ItemMenu> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHover = true),
      onExit: (_) => setState(() => _isHover = false),
      child: ListTile(
        onTap: widget.onTap,
        leading: Icon(widget.icone, color: const Color(0xFF1A73E8)),
        title: Text(
          widget.titulo,
          style: GoogleFonts.inter(
            color: _isHover ? const Color(0xFF1A73E8) : Colors.white, 
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}