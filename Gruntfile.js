module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

		copy: {
			bootstrap: {
				files: [{
					expand: true, 
					cwd: 'src/bower_components/bootstrap/dist/', 
					src: ['**'], dest: 'assets/vendor/bootstrap/'
				}]
			},
			index: {
				src: 'about-jon-beebe.html',
		    dest: 'index.html'
			}
		},
    sass: {
			build: {
	      files: {
	        'assets/styles/styles.css': 'src/styles/styles.scss'
	      }
			}
    },
    assemble: {
      options: {
        assets: 'assets',
				helpers: 'src/helpers/**/*.js',
        partials: ['src/includes/**/*.hbs'],
        layoutdir: 'src/layouts/',
        data: ['src/data/*.{json,yml}']
      },
      pages: {
				files: [{
					expand: true,
					cwd: 'src/', 
					flatten: true,
					src: ['pages/*.{hbs,md}'], 
					dest: './'
				}]
      },
      projects: {
				files: [{
					expand: true,
					cwd: 'src/', 
					flatten: true,
					src: ['projects/*.{hbs,md}'], 
					dest: './projects/'
				}]
      }
    },
		
		clean: {
		  site: ['blog', 'projects', '*.html']
		},
		
    watch: {
      site: {
        files: [
					'src/**/*.{hbs,md,scss}'
				],
        tasks: ['dist'],
        options: {
          spawn: false,
					livereload: true
        }
      }
    },
		
    connect: {
      options: {
        port: 8000,
        livereload: 35729,
        // Change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'
      },
			site: {
				keepalive: true
			}
    }
  });

  // Load the plugin that provides the 'uglify' task.
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('assemble');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-connect');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-clean');


  // Default task(s).
  grunt.registerTask('dist', ['clean', 'assemble', 'sass', 'copy']);
  grunt.registerTask('default', ['dist']);

};
