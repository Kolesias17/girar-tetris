import 'dart:html';

/// Elemento Canvas
CanvasElement canvas = null;
CanvasRenderingContext2D renderer = null;

/// Representa un elemento de Tetris
class TetrisElement
{
    /// Arreglo con la información de la pieza
    var pieceMap = [];
    
    /// Coordenada X donde dibujar
    int drawX = 10;
    
    /// Coordenada Y donde dibujar
    int drawY = 10;
    
    /// Tamaño
    int drawWidth = 25;
    
    /// Constructor
    TetrisElement( this.pieceMap, int number )
    {
        // No sé que hice... pero funciona
        drawY = ((drawWidth * 6) * number) - 50;
    }
    
    /// Rota la pieza hacia la derecha
    void rotateRight()
    {
        int length  = pieceMap.length;
        int last    = length - 1;
        
        var newPiece = [];
        
        for( int i = 0; i <= length; ++i ) {
            var section = [];
            
            for( int e = last; e >= 0; --e ) {
                if ( i <= (pieceMap[e].length-1) )
                    section.add(pieceMap[e][i]);
            }
    
            if ( section.isNotEmpty )
                newPiece.add(section);
        }

        pieceMap = newPiece;
    }
    
    /// Dibuja la pieza en el canvas
    void render()
    {
        // Posición y tamaño iniciales
        int x       = drawX;
        int y       = drawY;
        int width   = drawWidth;
    
        // Por cada arreglo dentro del arreglo
        pieceMap.forEach((map) {
            // Reiniciamos la posición X
            // y aumentamos a la Y
            x = drawX;
            y += (width + 1);
            
            // Por cada entero dentro del arreglo
            map.forEach((status) {
                // Aumentamos la X para dibujar más a la derecha
                x += (width + 1);
                
                // Espacio vacio
                if ( status == 0 ) {
                    renderer.setFillColorRgb(255, 255, 255);
                }
                // Espacio ocupado (rojo)
                else {
                    renderer.setFillColorRgb(255, 0, 0);
                }
    
                // Dibujamos en el canvas
                renderer.fillRect( x, y, width, width );
            });
        });
    }
}

/// Piezas del tetris
List<TetrisElement> pieces = new List<TetrisElement>();

/// Inicio del programa
void main()
{
    canvas = querySelector('canvas') as CanvasElement;
        
    // Creamos el <canvas>
    if ( canvas == null ) {
        canvas = new CanvasElement();
        querySelector('body').append( canvas );
    }
    
    // Pantalla completa
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    
    // Cada que se haga clic sobre el canvas, rotamos todas las piezas
    canvas.onClick.listen(onClick);
    
    // Context2D
    renderer = canvas.context2D;
    
    // Creamos las piezas
    createPieces();
    
    // Empezamos a dibujar en el canvas
    frame();
}

/// Al hacer clic en el canvas
void onClick( MouseEvent e )
{
    // Rotamos cada pieza
    pieces.forEach((TetrisElement piece) {
        piece.rotateRight();
    });
}

/// Crea las piezas que se dibujaran
void createPieces()
{
    pieces.add(new TetrisElement([[1, 1, 0], [0, 1, 1]], 1));      // Z
    pieces.add(new TetrisElement([[1,1,1], [0,1,0], [0,1,0]], 2)); // T
    pieces.add(new TetrisElement([[1,0],[1,0],[1,1]], 3));        // L
}

void frame( [n] )
{
    // Solicitamos al navegador volver a ejecutar
    // esta función en cada frame.
    window.requestAnimationFrame( frame );
    
    // Limpiamos el frame anterior
    renderer.clearRect(0, 0, canvas.width, canvas.height);

    // Dibujamos cada pieza
    pieces.forEach((TetrisElement piece) {
        piece.render();
    });
}

