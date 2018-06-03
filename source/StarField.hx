package;

import flixel.system.FlxAssets.FlxShader;

class StarField extends FlxShader {
    @:glFragmentSource('
        #pragma header

        uniform float time;
        float speed = 2.0;

        float rand(vec2 co){
            return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
        }

        void main() {

            vec2 scale = vec2(1.0,1.0);

            vec2 coord = openfl_TextureCoordv; // Copy for editing
            /*
               vec4 color = texture2D(bitmap, coord);

            if(color == vec4(1,1,1,1)) {
                gl_FragColor = vec4(1,1,1,1);
            }

            else {
            */

                //vec2 offset = scale / 2.0;

                //float sf = coord.y;

                //coord.x = (coord.x-offset.x)/(0.5+sf)*(0.85)  +offset.x; // Scale x based on y (trapezium)

                //vec4 color = texture2D(bitmap, coord);

                //if(color.r == color.g && color.r == color.b) {
                    float dx = (openfl_TextureCoordv.x - scale.x/2.0);
                    float dy = (openfl_TextureCoordv.y - scale.y/2.0);
                    float r2 = dx*dx+dy*dy;
                    float at = round(atan(dy,dx)*30.0) / 30.0;

                    float amtNum = 3.0;

                    vec4 color = vec4((mod(r2 - time * speed + rand(vec2(0.0,at))*amtNum, amtNum)-amtNum+0.2)*sqrt(r2*16.0));
                //}

                gl_FragColor = color;
            //}
        }')

    public function new() {
        super();
    }

}
